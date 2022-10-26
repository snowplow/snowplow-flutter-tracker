// Copyright (c) 2022 Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await SnowplowTests.resetMicro();
  });

  // Use a different namespace for every tracker test

  testWidgets("sets and changes user id", (WidgetTester tester) async {
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'test',
        endpoint: SnowplowTests.microEndpoint,
        subjectConfig: const SubjectConfiguration(userId: 'XYZ'));

    await tracker
        .track(const Structured(category: 'category', action: 'action'));

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) && (events[0]['event']['user_id'] == 'XYZ')),
        isTrue);

    await tracker.setUserId('ABC');

    await SnowplowTests.resetMicro();
    await tracker
        .track(const Structured(category: 'category', action: 'action'));

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

    SnowplowTracker withoutContext = await Snowplow.createTracker(
        namespace: 'withoutContext',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(webPageContext: false));

    SnowplowTracker withContext = await Snowplow.createTracker(
        namespace: 'withContext',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(webPageContext: true));

    await withoutContext
        .track(const Structured(category: 'category', action: 'action'));
    await withContext
        .track(const Structured(category: 'category', action: 'action'));

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
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'gdpr',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(),
        gdprConfig: const GdprConfiguration(
            basisForProcessing: 'consent',
            documentId: 'consentDoc-abc123',
            documentVersion: '0.1.0',
            documentDescription:
                'this document describes consent basis for processing'));

    tracker.track(const Structured(category: 'category', action: 'action'));

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

  testWidgets("sets app ID and platform based on configuration",
      (WidgetTester tester) async {
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'app-platform',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(
            appId: 'App Z', devicePlatform: DevicePlatform.iot));

    await tracker
        .track(const Structured(category: 'category', action: 'action'));

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['app_id'] == 'App Z') &&
            (events[0]['event']['platform'] == 'iot')),
        isTrue);
  });

  testWidgets("screenContext and applicationContext on by default",
      (WidgetTester tester) async {
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'screen-on', endpoint: SnowplowTests.microEndpoint);

    await tracker
        .track(const Structured(category: 'category', action: 'action'));

    await SnowplowTests.checkMicroGood((dynamic events) {
      if (events.length != 1) {
        return false;
      }
      String eventType =
          events[0]['event']['v_tracker'].toString().substring(0, 2);
      // screenContext/applicationContext are not available on web
      if (eventType == 'and' || eventType == 'ios') {
        Iterable appContexts = events[0]['event']['contexts']['data']
            .where((x) => x['schema'].toString().contains('application'));
        expect(appContexts.isNotEmpty, isTrue);

        Iterable screenContexts = events[0]['event']['contexts']['data']
            .where((x) => x['schema'].toString().contains('screen\\/'));
        expect(screenContexts.isNotEmpty, isTrue);
      }
      return true;
    });

    await SnowplowTests.resetMicro();

    SnowplowTracker tracker2 = await Snowplow.createTracker(
        namespace: 'screen-off',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(
            screenContext: false, applicationContext: false));

    await tracker2
        .track(const Structured(category: 'category', action: 'action'));

    await SnowplowTests.checkMicroGood((dynamic events) {
      if (events.length != 1) {
        return false;
      }
      String eventType =
          events[0]['event']['v_tracker'].toString().substring(0, 2);
      // screenContext/applicationContext are not available on web
      if (eventType == 'and' || eventType == 'ios') {
        Iterable appContexts = events[0]['event']['contexts']['data']
            .where((x) => x['schema'].toString().contains('application'));
        expect(appContexts.isEmpty, isTrue);

        Iterable screenContexts = events[0]['event']['contexts']['data']
            .where((x) => x['schema'].toString().contains('screen\\/'));
        expect(screenContexts.isEmpty, isTrue);
      }
      return true;
    });
  });
}
