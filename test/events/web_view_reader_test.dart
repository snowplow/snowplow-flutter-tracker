import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/events/web_view_reader.dart';

void main() {
  test('WebViewReader toMap only includes non-null values', () {
    const reader = WebViewReader(
      eventName: 'test_event',
      trackerVersion: '1.0.0',
      useragent: 'test-agent',
      value: 42.0,
      pingXOffsetMin: 10,
      pingYOffsetMax: 30,
    );

    final map = reader.toMap();

    expect(map.containsKey('eventName'), isTrue);
    expect(map.containsKey('trackerVersion'), isTrue);
    expect(map.containsKey('useragent'), isTrue);
    expect(map.containsKey('value'), isTrue);
    expect(map.containsKey('pingXOffsetMin'), isTrue);
    expect(map.containsKey('pingYOffsetMax'), isTrue);

    expect(map.containsKey('pageUrl'), isFalse);
    expect(map.containsKey('category'), isFalse);
  });

  test('WebViewReader fromMap should populate all fields correctly', () {
    final map = {
      'eventName': 'click',
      'trackerVersion': '2.0.1',
      'useragent': 'agent',
      'pageUrl': 'https://example.com',
      'pageTitle': 'Example Page',
      'referrer': 'https://referrer.com',
      'category': 'ui',
      'action': 'tap',
      'label': 'submit',
      'property': 'form',
      'value': 1.23,
      'pingXOffsetMin': 5,
      'pingXOffsetMax': 10,
      'pingYOffsetMin': 15,
      'pingYOffsetMax': 20,
    };

    final reader = WebViewReader.fromMap(map);
    final result = reader.toMap();

    expect(result['eventName'], equals('click'));
    expect(result['trackerVersion'], equals('2.0.1'));
    expect(result['useragent'], equals('agent'));
    expect(result['pageUrl'], equals('https://example.com'));
    expect(result['pageTitle'], equals('Example Page'));
    expect(result['referrer'], equals('https://referrer.com'));
    expect(result['category'], equals('ui'));
    expect(result['action'], equals('tap'));
    expect(result['label'], equals('submit'));
    expect(result['property'], equals('form'));
    expect(result['value'], equals(1.23));
    expect(result['pingXOffsetMin'], equals(5));
    expect(result['pingXOffsetMax'], equals(10));
    expect(result['pingYOffsetMin'], equals(15));
    expect(result['pingYOffsetMax'], equals(20));
  });

  test('WebViewReader fromMap handles missing optional fields', () {
    final map = {
      'eventName': 'click',
      'trackerVersion': '2.0.1',
      'useragent': 'agent',
      // Missing pageUrl, pageTitle, referrer, category, action, label, property, value
      'pingXOffsetMin': 5,
      'pingXOffsetMax': 10,
      'pingYOffsetMin': 15,
      'pingYOffsetMax': 20,
    };

    final reader = WebViewReader.fromMap(map);
    final result = reader.toMap();

    expect(result['eventName'], equals('click'));
    expect(result['trackerVersion'], equals('2.0.1'));
    expect(result['useragent'], equals('agent'));
    expect(result.containsKey('pageUrl'), isFalse);
    expect(result.containsKey('pageTitle'), isFalse);
    expect(result.containsKey('referrer'), isFalse);
    expect(result.containsKey('category'), isFalse);
    expect(result.containsKey('action'), isFalse);
    expect(result.containsKey('label'), isFalse);
    expect(result.containsKey('property'), isFalse);
    expect(result.containsKey('value'), isFalse);
    expect(result['pingXOffsetMin'], equals(5));
    expect(result['pingXOffsetMax'], equals(10));
    expect(result['pingYOffsetMin'], equals(15));
    expect(result['pingYOffsetMax'], equals(20));
  });

  test('WebViewReader fromMap with self-describing data', () {
    final map = {
      'selfDescribingEventData': {
        'schema': 'iglu:com.example/schema/jsonschema/1-0-0',
        'data': {'key': 'value'},
      },
      'eventName': 'test_event',
      'trackerVersion': '1.0.0',
      'useragent': 'test-agent',
      'pageUrl': 'https://example.com',
      'pageTitle': 'Example Page',
      'referrer': 'https://referrer.com',
      'category': 'ui',
      'action': 'tap',
      'label': 'submit',
      'property': 'form',
      'value': 1.23,
    };

    final reader = WebViewReader.fromMap(map);
    expect(reader.selfDescribingEventData, isNotNull);
    expect(reader.selfDescribingEventData!.schema,
        equals('iglu:com.example/schema/jsonschema/1-0-0'));
  });

  test('WebViewReader endpoint returns expected value', () {
    const reader = WebViewReader();
    expect(reader.endpoint(), equals('trackWebViewReader'));
  });

  test('WebViewReader toMap does not throw when all fields are null', () {
    const reader = WebViewReader();
    expect(() => reader.toMap(), returnsNormally);
    expect(reader.toMap().isEmpty, isTrue);
  });
}
