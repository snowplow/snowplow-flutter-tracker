import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/configurations.dart';
import 'package:snowplow_flutter_tracker/events.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'package:snowplow_flutter_tracker/helpers.dart';
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
        trackerConfig: TrackerConfiguration(logLevel: 'verbose'),
        emitterConfig: EmitterConfiguration(threadPoolSize: 10),
        sessionConfig: SessionConfiguration(backgroundTimeout: 10.01),
        gdprConfig: GdprConfiguration(
            basisForProcessing: 'b',
            documentId: 'd',
            documentVersion: 'v',
            documentDescription: 'e'),
        gcConfig: [
          GlobalContextsConfiguration(tag: 't1', globalContexts: [
            {'c': 100},
            {'t': 200}
          ]),
          GlobalContextsConfiguration(tag: 't2', globalContexts: [
            {'x': 0}
          ])
        ]);
    await Snowplow.createTracker(config);

    expect(method, equals('createTracker'));
    expect(arguments['namespace'], equals('tns1'));
    expect(arguments['networkConfig']['endpoint'],
        equals('https://snowplowanalytics.com'));
    expect(arguments['trackerConfig']['logLevel'], equals('verbose'));
    expect(arguments['emitterConfig']['threadPoolSize'], equals(10));
    expect(arguments['emitterConfig']['byteLimitGet'], isNull);
    expect(arguments['sessionConfig']['backgroundTimeout'], equals(10.01));
    expect(arguments['gdprConfig']['documentId'], equals('d'));
    expect(arguments['gcConfig'].length, equals(2));
    expect(arguments['gcConfig'][0]['globalContexts'].length, equals(2));
    expect(arguments['gcConfig'][0]['tag'], equals('t1'));
    expect(arguments['gcConfig'][1]['globalContexts'].length, equals(1));
    expect(arguments['gcConfig'][1]['tag'], equals('t2'));
  });

  test('removes tracker', () async {
    await Snowplow.removeTracker('tns2');

    expect(method, equals('removeTracker'));
    expect(arguments['tracker'], equals('tns2'));
  });

  test('removes all trackers', () async {
    await Snowplow.removeAllTrackers();

    expect(method, equals('removeAllTrackers'));
    expect(arguments, isNull);
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

  test('sets network user ID', () async {
    await Snowplow.setNetworkUserId('n1', tracker: 'tns1');

    expect(method, equals('setNetworkUserId'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['networkUserId'], equals('n1'));
  });

  test('sets domain user ID', () async {
    await Snowplow.setDomainUserId('d1', tracker: 'tns1');

    expect(method, equals('setDomainUserId'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['domainUserId'], equals('d1'));
  });

  test('sets IP address', () async {
    await Snowplow.setIpAddress('192.150.112.10', tracker: 'tns1');

    expect(method, equals('setIpAddress'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['ipAddress'], equals('192.150.112.10'));
  });

  test('sets useragent', () async {
    await Snowplow.setUseragent('iOS 11', tracker: 'tns1');

    expect(method, equals('setUseragent'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['useragent'], equals('iOS 11'));
  });

  test('sets timezone', () async {
    await Snowplow.setTimezone('GMT+2', tracker: 'tns1');

    expect(method, equals('setTimezone'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['timezone'], equals('GMT+2'));
  });

  test('sets language', () async {
    await Snowplow.setLanguage('sk_SK', tracker: 'tns1');

    expect(method, equals('setLanguage'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['language'], equals('sk_SK'));
  });

  test('sets screen resolution', () async {
    await Snowplow.setScreenResolution(const Size(width: 800, height: 600),
        tracker: 'tns1');

    expect(method, equals('setScreenResolution'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['screenResolution'], equals([800, 600]));
  });

  test('sets screen viewport', () async {
    await Snowplow.setScreenViewport(const Size(width: 400, height: 200),
        tracker: 'tns1');

    expect(method, equals('setScreenViewport'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['screenViewport'], equals([400, 200]));
  });

  test('sets color depth', () async {
    await Snowplow.setColorDepth(20, tracker: 'tns1');

    expect(method, equals('setColorDepth'));
    expect(arguments['tracker'], equals('tns1'));
    expect(arguments['colorDepth'], equals(20));
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

  test('gets in background status', () async {
    returnValue = false;
    bool? isInBackground = await Snowplow.getIsInBackground(tracker: 'tns1');

    expect(method, equals('getIsInBackground'));
    expect(arguments['tracker'], 'tns1');
    expect(isInBackground, equals(false));
  });

  test('gets background index', () async {
    returnValue = 5;
    int? backgroundIndex = await Snowplow.getBackgroundIndex(tracker: 'tns1');

    expect(method, equals('getBackgroundIndex'));
    expect(arguments['tracker'], 'tns1');
    expect(backgroundIndex, equals(5));
  });

  test('gets foreground index', () async {
    returnValue = 7;
    int? foregroundIndex = await Snowplow.getForegroundIndex(tracker: 'tns1');

    expect(method, equals('getForegroundIndex'));
    expect(arguments['tracker'], 'tns1');
    expect(foregroundIndex, equals(7));
  });
}
