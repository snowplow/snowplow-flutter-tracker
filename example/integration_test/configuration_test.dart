import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'package:snowplow_flutter_tracker/events.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snowplow_flutter_tracker/configurations.dart';

import 'helpers.dart';
import 'package:snowplow_flutter_tracker_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await SnowplowTests.resetMicro();
  });

  testWidgets("sets and changes user id", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    await Snowplow.createTracker(const Configuration(
        namespace: 'test',
        networkConfig:
            NetworkConfiguration(endpoint: SnowplowTests.microEndpoint),
        trackerConfig: TrackerConfiguration(
            installAutotracking: false,
            lifecycleAutotracking: false,
            screenViewAutotracking: false),
        subjectConfig: SubjectConfiguration(userId: 'XYZ')));

    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: "test");

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) && (events[0]['event']['user_id'] == 'XYZ')),
        isTrue);

    await Snowplow.setUserId('ABC', tracker: 'test');

    await SnowplowTests.resetMicro();
    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: "test");

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) && (events[0]['event']['user_id'] == 'ABC')),
        isTrue);
  });

  // test installation event
}
