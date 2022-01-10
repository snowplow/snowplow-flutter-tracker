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
}
