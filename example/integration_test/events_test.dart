import 'package:uuid/uuid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'package:snowplow_flutter_tracker/events.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers.dart';
import 'package:snowplow_flutter_tracker_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await SnowplowTests.createTracker();
  });

  setUp(() async {
    await SnowplowTests.resetMicro();
  });

  testWidgets("tracks a structured event", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: "test");

    expect(
        await SnowplowTests.checkMicroCounts(
            (body) => (body['good'] == 1) && (body['bad'] == 0)),
        isTrue);
    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['se_category'] == 'category') &&
            (events[0]['event']['se_action'] == 'action')),
        isTrue);
  });

  testWidgets("tracks a self-describing event", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    const selfDescribing = SelfDescribing(
      schema: 'iglu:com.snowplowanalytics.snowplow/link_click/jsonschema/1-0-1',
      data: {'targetUrl': 'http://a-target-url.com'},
    );
    await Snowplow.track(selfDescribing, tracker: "test");

    expect(
        await SnowplowTests.checkMicroCounts(
            (body) => (body['good'] == 1) && (body['bad'] == 0)),
        isTrue);
    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['schema'] ==
                'iglu:com.snowplowanalytics.snowplow/link_click/jsonschema/1-0-1') &&
            (events[0]['event']['unstruct_event']['data']['data']
                    ['targetUrl'] ==
                'http://a-target-url.com')),
        isTrue);
  });

  testWidgets("tracks a screen view event", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));
    String id = const Uuid().v4();

    var screenView = ScreenView(id: id, name: 'name');
    await Snowplow.track(screenView, tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['data']['id'] ==
                id) &&
            (events[0]['event']['unstruct_event']['data']['data']['name'] ==
                'name')),
        isTrue);
  });

  testWidgets("tracks a timing event", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    var timing =
        const Timing(category: 'cat', variable: 'var', timing: 10, label: 'l');
    await Snowplow.track(timing, tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['data']['category'] ==
                'cat') &&
            (events[0]['event']['unstruct_event']['data']['data']['timing'] ==
                10)),
        isTrue);
  });

  testWidgets("tracks a consent granted event", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    const consentGranted = ConsentGranted(
      expiry: '2021-12-30T09:03:51.196111Z',
      documentId: '1234',
      version: '5',
      name: 'name1',
      documentDescription: 'description1',
    );
    await Snowplow.track(consentGranted, tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['data']['expiry'] ==
                '2021-12-30T09:03:51.196111Z')),
        isTrue);
  });

  testWidgets("tracks a consent withdrawn event", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    const consentWithdrawn = ConsentWithdrawn(
      all: false,
      documentId: '1234',
      version: '5',
      name: 'name1',
      documentDescription: 'description1',
    );
    await Snowplow.track(consentWithdrawn, tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['data']['all'] ==
                false)),
        isTrue);
  });

  // test session context - keeps session ids and first event id the same
  testWidgets("maintains the same session context",
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: "test");

    dynamic clientSession1;
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length == 0) {
            return false;
          }
          clientSession1 = events[0]['event']['contexts']['data'].firstWhere(
              (x) => x['schema'].toString().contains('client_session'));
          return true;
        }),
        isTrue);

    expect(clientSession1['data']['firstEventId'], isNotNull);
    expect(clientSession1['data']['sessionId'], isNotNull);
    expect(clientSession1['data']['userId'], isNotNull);

    await SnowplowTests.resetMicro();

    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: "test");

    dynamic clientSession2;
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length == 0) {
            return false;
          }
          clientSession2 = events[0]['event']['contexts']['data'].firstWhere(
              (x) => x['schema'].toString().contains('client_session'));
          return true;
        }),
        isTrue);

    expect(clientSession1['data']['firstEventId'],
        equals(clientSession2['data']['firstEventId']));
    expect(clientSession1['data']['sessionId'],
        equals(clientSession2['data']['sessionId']));
    expect(clientSession1['data']['userId'],
        equals(clientSession2['data']['userId']));
  });
}
