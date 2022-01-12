import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/configurations/configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/gdpr_configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/network_configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/tracker_configuration.dart';
import 'package:snowplow_flutter_tracker/events/consent_granted.dart';
import 'package:snowplow_flutter_tracker/events/consent_withdrawn.dart';
import 'package:snowplow_flutter_tracker/events/event.dart';
import 'package:snowplow_flutter_tracker/events/screen_view.dart';
import 'package:snowplow_flutter_tracker/events/self_describing.dart';
import 'package:snowplow_flutter_tracker/events/structured.dart';
import 'package:snowplow_flutter_tracker/events/timing.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'package:uuid/uuid.dart';

void main() {
  const MethodChannel channel = MethodChannel('snowplow_flutter_tracker');
  MethodCall? methodCall;
  dynamic returnValue;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    methodCall = null;
    returnValue = null;
    channel.setMockMethodCallHandler((MethodCall call) async {
      methodCall = call;
      return returnValue;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('createsTrackerWithConfiguration', () async {
    const Configuration config = Configuration(
        namespace: 'tns1',
        networkConfig:
            NetworkConfiguration(endpoint: 'https://snowplowanalytics.com'),
        trackerConfig: TrackerConfiguration(base64Encoding: true),
        gdprConfig: GdprConfiguration(
            basisForProcessing: 'b',
            documentId: 'd',
            documentVersion: 'v',
            documentDescription: 'e'));
    await Snowplow.createTrackerWithConfiguration(config);

    expect(
        methodCall,
        isMethodCall('createTracker', arguments: {
          'namespace': 'tns1',
          'networkConfig': {'endpoint': 'https://snowplowanalytics.com'},
          'trackerConfig': {'base64Encoding': true},
          'gdprConfig': {
            'basisForProcessing': 'b',
            'documentId': 'd',
            'documentVersion': 'v',
            'documentDescription': 'e',
          }
        }));
  });

  test('tracks structured event', () async {
    Event event = const Structured(category: 'c1', action: 'a1');
    await Snowplow.track(event, tracker: 'tns3');

    expect(
        methodCall,
        isMethodCall('trackStructured', arguments: {
          'tracker': 'tns3',
          'eventData': {'category': 'c1', 'action': 'a1'}
        }));
  });

  test('tracks structured event with context', () async {
    Event event = const Structured(category: 'c1', action: 'a1');
    await Snowplow.track(event, tracker: 'tns3', contexts: [
      const SelfDescribing(schema: 'schema://schema1', data: {'x': 'y'})
    ]);

    expect(
        methodCall,
        isMethodCall('trackStructured', arguments: {
          'tracker': 'tns3',
          'eventData': {'category': 'c1', 'action': 'a1'},
          'contexts': [
            {
              'schema': 'schema://schema1',
              'data': {'x': 'y'}
            }
          ]
        }));
  });

  test('tracks self-describing event', () async {
    Event event =
        const SelfDescribing(schema: 'schema://schema2', data: {'y': 'z'});
    await Snowplow.track(event, tracker: 'tns2');

    expect(
        methodCall,
        isMethodCall('trackSelfDescribing', arguments: {
          'tracker': 'tns2',
          'eventData': {
            'schema': 'schema://schema2',
            'data': {'y': 'z'}
          }
        }));
  });

  test('tracks screen view event', () async {
    String id = const Uuid().v4();
    Event event = ScreenView(name: 'screen1', id: id);
    await Snowplow.track(event, tracker: 'tns2');

    expect(
        methodCall,
        isMethodCall('trackScreenView', arguments: {
          'tracker': 'tns2',
          'eventData': {'name': 'screen1', 'id': id}
        }));
  });

  test('tracks timing event', () async {
    Event event = const Timing(category: 'c1', variable: 'v1', timing: 34);
    await Snowplow.track(event, tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('trackTiming', arguments: {
          'tracker': 'tns1',
          'eventData': {'category': 'c1', 'variable': 'v1', 'timing': 34}
        }));
  });

  test('tracks consent granted event', () async {
    Event event = const ConsentGranted(
      expiry: '2021-10-10',
      documentId: 'd1',
      version: '10',
    );
    await Snowplow.track(event, tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('trackConsentGranted', arguments: {
          'tracker': 'tns1',
          'eventData': {
            'expiry': '2021-10-10',
            'documentId': 'd1',
            'version': '10'
          }
        }));
  });

  test('tracks consent withdrawn event', () async {
    Event event = const ConsentWithdrawn(
      all: true,
      documentId: 'd1',
      version: '10',
    );
    await Snowplow.track(event, tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('trackConsentWithdrawn', arguments: {
          'tracker': 'tns1',
          'eventData': {'all': true, 'documentId': 'd1', 'version': '10'}
        }));
  });

  test('sets user ID', () async {
    await Snowplow.setUserId('u1', tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('setUserId',
            arguments: {'tracker': 'tns1', 'userId': 'u1'}));
  });

  test('gets session user ID', () async {
    returnValue = 'u1';
    String? sessionUserId = await Snowplow.getSessionUserId(tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('getSessionUserId', arguments: {
          'tracker': 'tns1',
        }));
    expect(sessionUserId, equals('u1'));
  });

  test('gets session ID', () async {
    returnValue = 's1';
    String? sessionId = await Snowplow.getSessionId(tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('getSessionId', arguments: {
          'tracker': 'tns1',
        }));
    expect(sessionId, equals('s1'));
  });

  test('gets session index', () async {
    returnValue = 10;
    int? sessionIndex = await Snowplow.getSessionIndex(tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('getSessionIndex', arguments: {
          'tracker': 'tns1',
        }));
    expect(sessionIndex, equals(10));
  });
}
