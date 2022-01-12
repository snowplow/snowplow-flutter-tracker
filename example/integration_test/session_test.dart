import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'package:snowplow_flutter_tracker/events/structured.dart';
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

  testWidgets("tracks the same session information as returned from API",
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: "test");

    dynamic clientSession;
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length != 1) {
            return false;
          }
          clientSession = events[0]['event']['contexts']['data'].firstWhere(
              (x) => x['schema'].toString().contains('client_session'));
          return true;
        }),
        isTrue);

    String? sessionId = await Snowplow.getSessionId(tracker: 'test');
    String? sessionUserId = await Snowplow.getSessionUserId(tracker: 'test');
    int? sessionIndex = await Snowplow.getSessionIndex(tracker: 'test');

    expect(clientSession['data']['sessionId'], equals(sessionId));
    expect(clientSession['data']['userId'], equals(sessionUserId));
    expect(clientSession['data']['sessionIndex'], equals(sessionIndex));
  });
}
