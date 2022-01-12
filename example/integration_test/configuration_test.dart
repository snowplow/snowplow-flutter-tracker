import 'package:flutter/foundation.dart';
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

    await Snowplow.createTracker(
        namespace: 'test',
        endpoint: SnowplowTests.microEndpoint,
        subjectConfig: const SubjectConfiguration(userId: 'XYZ'));

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

  testWidgets("adds web page context depending on configuration",
      (WidgetTester tester) async {
    if (!kIsWeb) {
      return;
    }
    await tester.pumpWidget(const MyApp(testing: true));

    await Snowplow.createTracker(
        namespace: 'withoutContext',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(webPageContext: false));

    await Snowplow.createTracker(
        namespace: 'withContext',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(webPageContext: true));

    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: 'withoutContext');
    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: 'withContext');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 2) &&
            (events
                    .where((x) => (x['contexts'] as List).contains(
                        'iglu:com.snowplowanalytics.snowplow/web_page/jsonschema/1-0-0'))
                    .length ==
                1) &&
            (events
                    .where((x) => !(x['contexts'] as List).contains(
                        'iglu:com.snowplowanalytics.snowplow/web_page/jsonschema/1-0-0'))
                    .length ==
                1)),
        isTrue);
  });

  testWidgets("attaches gdpr context to events", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(testing: true));

    await Snowplow.createTracker(
        namespace: 'test',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(),
        gdprConfig: const GdprConfiguration(
            basisForProcessing: 'consent',
            documentId: 'consentDoc-abc123',
            documentVersion: '0.1.0',
            documentDescription:
                'this document describes consent basis for processing'));

    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length != 1) {
            return false;
          }
          dynamic context = events[0]['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('gdpr'));
          return (context['data']['documentId'] == 'consentDoc-abc123') &&
              (context['data']['documentVersion'] == '0.1.0') &&
              (context['data']['basisForProcessing'] == 'consent') &&
              (context['data']['documentDescription'] ==
                  'this document describes consent basis for processing');
        }),
        isTrue);
  });

  // test installation event
}
