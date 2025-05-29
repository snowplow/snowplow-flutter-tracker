import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';
import 'package:snowplow_tracker/events/web_view_reader.dart';
import 'package:snowplow_tracker/web_view_integration.dart';

class MockTracker implements SnowplowTracker {
  final List<Event> trackedEvents = [];
  @override
  String namespace = 'testNamespace';

  @override
  Future<void> track(Event event, {List<SelfDescribing>? contexts}) async {
    trackedEvents.add(event);
  }

  // Add all unimplemented methods as no-op or dummy
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('MessageEvent', () {
    test('fromMap creates correct event based on command', () {
      final map = {
        'schema': 'iglu:test/schema/jsonschema/1-0-0',
        'data': {'key': 'value'}
      };
      final event = MessageEvent.fromMap('trackSelfDescribingEvent', map);
      expect(event.selfDescribing, isNotNull);
    });

    test('toEvent returns the correct event', () {
      final map = {
        'schema': 'iglu:test/schema/jsonschema/1-0-0',
        'data': {'key': 'value'}
      };
      final event = MessageEvent.fromMap('trackSelfDescribingEvent', map);
      final result = event.toEvent();
      expect(result, isA<SelfDescribing>());
      expect((result as SelfDescribing).schema,
          equals('iglu:test/schema/jsonschema/1-0-0'));
    });

    test('toEvent returns WebViewReader when command is trackWebViewEvent', () {
      final map = {
        'eventName': 'test_event',
        'trackerVersion': '1.0.0',
        'useragent': 'test-agent',
        'value': 42.0,
        'pingXOffsetMin': 10,
        'pingYOffsetMax': 30,
      };
      final event = MessageEvent.fromMap('trackWebViewEvent', map);
      final result = event.toEvent();
      expect(result, isA<WebViewReader>());
      expect((result as WebViewReader).eventName, equals('test_event'));
    });

    test('toEvent returns Structured when command is trackStructEvent', () {
      final map = {
        'category': 'test_category',
        'action': 'test_action',
        'label': 'test_label',
        'property': 'test_property',
        'value': 100
      };
      final event = MessageEvent.fromMap('trackStructEvent', map);
      final result = event.toEvent();
      expect(result, isA<Structured>());
      expect((result as Structured).category, equals('test_category'));
    });

    test('toEvent returns ScreenView when command is trackScreenView', () {
      final map = {
        'name': 'test_screen',
        'type': 'full',
        'transitionType': 'none'
      };
      final event = MessageEvent.fromMap('trackScreenView', map);
      final result = event.toEvent();
      expect(result, isA<ScreenView>());
      expect((result as ScreenView).name, equals('test_screen'));
    });

    test('toEvent returns PageViewEvent when command is trackPageView', () {
      final map = {
        'title': 'test_page',
        'url': 'https://example.com',
      };
      final event = MessageEvent.fromMap('trackPageView', map);
      final result = event.toEvent();
      expect(result, isA<PageViewEvent>());
      expect((result as PageViewEvent).title, equals('test_page'));
    });

    test('toEvent throws exception when no valid event found', () {
      const event = MessageEvent();
      expect(() => event.toEvent(), throwsException);
    });
  });

  group('Message', () {
    test('fromJson deserializes correctly', () {
      const json = '''
      {
        "command": "trackSelfDescribingEvent",
        "event": {
          "schema": "iglu:test/schema/jsonschema/1-0-0",
          "data": {"key": "value"}
        }
      }
      ''';
      final message = Message.fromJson(json);
      expect(message.command, equals('trackSelfDescribingEvent'));
      expect(message.event.selfDescribing, isNotNull);
    });

    test('trackEvent respects tracker namespace filtering', () {
      const json = '''
      {
        "command": "trackSelfDescribingEvent",
        "event": {
          "schema": "iglu:test/schema/jsonschema/1-0-0",
          "data": {"key": "value"}
        },
        "trackers": ["wrongNamespace"]
      }
      ''';
      final message = Message.fromJson(json);
      final tracker = MockTracker();
      message.trackEvent(tracker, false);
      expect(tracker.trackedEvents, isEmpty);
    });

    test('trackEvent tracks when namespace matches', () {
      const json = '''
      {
        "command": "trackSelfDescribingEvent",
        "event": {
          "schema": "iglu:test/schema/jsonschema/1-0-0",
          "data": {"key": "value"}
        },
        "trackers": ["testNamespace"]
      }
      ''';
      final message = Message.fromJson(json);
      final tracker = MockTracker();
      message.trackEvent(tracker, false);
      expect(tracker.trackedEvents.length, equals(1));
    });
  });

  group('WebViewIntegration', () {
    test('handleMessage parses and tracks valid JSON', () {
      final tracker = MockTracker();
      final integration = WebViewIntegration(tracker: tracker);
      const json = '''
      {
        "command": "trackSelfDescribingEvent",
        "event": {
          "schema": "iglu:test/schema/jsonschema/1-0-0",
          "data": {"key": "value"}
        }
      }
      ''';
      integration.handleMessage(json);
      expect(tracker.trackedEvents.length, equals(1));
    });

    test('handleMessage ignores empty message', () {
      final tracker = MockTracker();
      final integration = WebViewIntegration(tracker: tracker);
      integration.handleMessage('');
      expect(tracker.trackedEvents.length, equals(0));
    });

    group('ignoreTrackerNamespace configuration', () {
      test(
          'handleMessage does not track when ignoreTrackerNamespace is false and namespace mismatches',
          () {
        final tracker = MockTracker();
        final integration =
            WebViewIntegration(tracker: tracker, ignoreTrackerNamespace: false);
        const json = '''
        {
          "command": "trackSelfDescribingEvent",
          "event": {
            "schema": "iglu:test/schema/jsonschema/1-0-0",
            "data": {"key": "value"}
          },
          "trackers": ["otherNamespace"]
        }
        ''';
        integration.handleMessage(json);
        expect(tracker.trackedEvents.length, equals(0));
      });

      test(
          'handleMessage tracks when ignoreTrackerNamespace is false and namespace matches',
          () {
        final tracker = MockTracker();
        final integration =
            WebViewIntegration(tracker: tracker, ignoreTrackerNamespace: false);
        const json = '''
        {
          "command": "trackSelfDescribingEvent",
          "event": {
            "schema": "iglu:test/schema/jsonschema/1-0-0",
            "data": {"key": "value"}
          },
          "trackers": ["testNamespace"]
        }
        ''';
        integration.handleMessage(json);
        expect(tracker.trackedEvents.length, equals(1));
      });

      test(
          'handleMessage tracks when ignoreTrackerNamespace is true regardless of namespace',
          () {
        final tracker = MockTracker();
        final integration =
            WebViewIntegration(tracker: tracker, ignoreTrackerNamespace: true);
        const json = '''
        {
          "command": "trackSelfDescribingEvent",
          "event": {
            "schema": "iglu:test/schema/jsonschema/1-0-0",
            "data": {"key": "value"}
          },
          "trackers": ["otherNamespace"]
        }
        ''';
        integration.handleMessage(json);
        expect(tracker.trackedEvents.length, equals(1));
      });
    });
  });
}
