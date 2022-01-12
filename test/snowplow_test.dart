import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/configurations.dart';
import 'package:snowplow_flutter_tracker/events.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'package:uuid/uuid.dart';

void main() {
  const MethodChannel channel = MethodChannel('snowplow_flutter_tracker');
  String? method;
  dynamic arguments;
  dynamic returnValue;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    returnValue = null;
    method = null;
    arguments = null;
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      method = methodCall.method;
      arguments = methodCall.arguments;
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
    await Snowplow.createTracker(config);

    expect(method, equals('createTracker'));
    expect(arguments['namespace'], equals('tns1'));
    expect(arguments['networkConfig']['endpoint'],
        equals('https://snowplowanalytics.com'));
    expect(arguments['trackerConfig']['base64Encoding'], isTrue);
    expect(arguments['gdprConfig']['documentId'], equals('d'));
  });

  test('tracks structured event', () async {
    Event event = const Structured(category: 'c1', action: 'a1');
    await Snowplow.track(event, tracker: 'tns3');

    expect(method, equals('trackStructured'));
    expect(arguments['tracker'], equals('tns3'));
    expect(arguments['eventData']['category'], equals('c1'));
    expect(arguments['eventData']['action'], equals('a1'));
    expect(arguments['contexts'], isNull);
  });

  test('tracks structured event with context', () async {
    Event event = const Structured(category: 'c1', action: 'a1');
    await Snowplow.track(event, tracker: 'tns3', contexts: [
      const SelfDescribing(schema: 'schema://schema1', data: {'x': 'y'})
    ]);

    expect(arguments['contexts'].length, equals(1));
    expect(arguments['contexts'][0]['schema'], equals('schema://schema1'));
    expect(arguments['contexts'][0]['data']['x'], equals('y'));
  });

  test('tracks self-describing event', () async {
    Event event =
        const SelfDescribing(schema: 'schema://schema2', data: {'y': 'z'});
    await Snowplow.track(event, tracker: 'tns2');

    expect(method, equals('trackSelfDescribing'));
    expect(arguments['tracker'], equals('tns2'));
    expect(arguments['eventData']['schema'], equals('schema://schema2'));
    expect(arguments['eventData']['data']['y'], equals('z'));
  });

  test('tracks screen view event', () async {
    String id = const Uuid().v4();
    Event event = ScreenView(name: 'screen1', id: id);
    await Snowplow.track(event, tracker: 'tns2');

    expect(method, equals('trackScreenView'));
    expect(arguments['tracker'], equals('tns2'));
    expect(arguments['eventData']['name'], equals('screen1'));
    expect(arguments['eventData']['id'], equals(id));
  });

  test('tracks timing event', () async {
    Event event = const Timing(category: 'c1', variable: 'v1', timing: 34);
    await Snowplow.track(event, tracker: 'tns1');

    expect(method, equals('trackTiming'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['eventData']['category'], equals('c1'));
    expect(arguments['eventData']['variable'], equals('v1'));
    expect(arguments['eventData']['timing'], equals(34));
  });

  test('tracks consent granted event', () async {
    Event event = const ConsentGranted(
      expiry: '2021-10-10',
      documentId: 'd1',
      version: '10',
    );
    await Snowplow.track(event, tracker: 'tns1');

    expect(method, equals('trackConsentGranted'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['eventData']['expiry'], equals('2021-10-10'));
    expect(arguments['eventData']['documentId'], equals('d1'));
    expect(arguments['eventData']['version'], equals('10'));
  });

  test('tracks consent withdrawn event', () async {
    Event event = const ConsentWithdrawn(
      all: true,
      documentId: 'd1',
      version: '10',
    );
    await Snowplow.track(event, tracker: 'tns1');

    expect(method, equals('trackConsentWithdrawn'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['eventData']['all'], equals(true));
    expect(arguments['eventData']['documentId'], equals('d1'));
    expect(arguments['eventData']['version'], equals('10'));
  });

  test('sets user ID', () async {
    await Snowplow.setUserId('u1', tracker: 'tns1');

    expect(method, equals('setUserId'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['userId'], equals('u1'));
  });

  test('gets session user ID', () async {
    returnValue = 'u1';
    String? sessionUserId = await Snowplow.getSessionUserId(tracker: 'tns1');

    expect(method, equals('getSessionUserId'));
    expect(arguments['tracker'], 'tns1');
    expect(sessionUserId, equals('u1'));
  });

  test('gets session ID', () async {
    returnValue = 's1';
    String? sessionId = await Snowplow.getSessionId(tracker: 'tns1');

    expect(method, equals('getSessionId'));
    expect(arguments['tracker'], 'tns1');
    expect(sessionId, equals('s1'));
  });

  test('gets session index', () async {
    returnValue = 10;
    int? sessionIndex = await Snowplow.getSessionIndex(tracker: 'tns1');

    expect(method, equals('getSessionIndex'));
    expect(arguments['tracker'], 'tns1');
    expect(sessionIndex, equals(10));
  });
}
