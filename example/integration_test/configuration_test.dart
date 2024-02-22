// Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uuid/uuid.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snowplow_tracker/configurations/emitter_configuration.dart';
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

  testWidgets("sets userAnonymisation", (WidgetTester tester) async {
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'user-anonymisation',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(
            userAnonymisation: true,
            sessionContext: true,
            platformContext: true));

    await tracker
        .track(const Structured(category: 'category', action: 'action'));

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['domain_userid'] == null)),
        isTrue);

    dynamic clientSession;
    await SnowplowTests.checkMicroGood((dynamic events) {
      Iterable sessions = events[0]['event']['contexts']['data']
          .where((x) => x['schema'].toString().contains('client_session'));
      if (sessions.length == 1) {
        clientSession = sessions.first;

        expect(clientSession['data']['userId'],
            equals('00000000-0000-0000-0000-000000000000'));
      }
      return true;
    });
  });

  testWidgets("sets serverAnonymisation", (WidgetTester tester) async {
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'server-anonymisation',
        endpoint: SnowplowTests.microEndpoint,
        emitterConfig: const EmitterConfiguration(serverAnonymisation: true));

    await tracker
        .track(const Structured(category: 'category', action: 'action'));

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['network_userid'] ==
                '00000000-0000-0000-0000-000000000000')),
        isTrue);
  });

  testWidgets("screenContext and applicationContext on by default",
      (WidgetTester tester) async {
    // screenContext/applicationContext are not available on web
    if (kIsWeb) {
      return;
    }

    SnowplowTracker trackerDefault = await Snowplow.createTracker(
        namespace: 'screen-on',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(
            screenEngagementAutotracking: false, lifecycleAutotracking: false));

    // track a screenView first to enable screenContext for subsequent events
    String id = const Uuid().v4();
    await trackerDefault.track(ScreenView(id: id, name: 'name'));
    await trackerDefault
        .track(const Structured(category: 'category', action: 'action'));

    await SnowplowTests.checkMicroGood((dynamic events) {
      if (events.length != 2) {
        return false;
      }
      Iterable appContexts = events[1]['event']['contexts']['data']
          .where((x) => x['schema'].toString().contains('application'));
      expect(appContexts.isNotEmpty, isTrue);

      Iterable screenContexts = events[1]['event']['contexts']['data']
          .where((x) => x['schema'].toString().contains('screen'));
      expect(screenContexts.isNotEmpty, isTrue);
      return true;
    });

    await SnowplowTests.resetMicro();

    SnowplowTracker trackerConfigured = await Snowplow.createTracker(
        namespace: 'screen-off',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(
            screenContext: false,
            applicationContext: false,
            lifecycleAutotracking: false,
            screenEngagementAutotracking: false));

    await trackerConfigured.track(ScreenView(id: id, name: 'name'));
    await trackerConfigured
        .track(const Structured(category: 'category', action: 'action'));

    await SnowplowTests.checkMicroGood((dynamic events) {
      if (events.length != 2) {
        return false;
      }
      Iterable appContexts = events[1]['event']['contexts']['data']
          .where((x) => x['schema'].toString().contains('application'));
      expect(appContexts.isEmpty, isTrue);

      Iterable screenContexts = events[1]['event']['contexts']['data']
          .where((x) => x['schema'].toString().contains('screen'));
      expect(screenContexts.isEmpty, isTrue);
      return true;
    });
  });

  testWidgets("sets custom request headers", (WidgetTester tester) async {
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'custom-headers',
        endpoint: SnowplowTests.microEndpoint,
        requestHeaders: {'Warning': 'works'});

    await tracker
        .track(const Structured(category: 'category', action: 'action'));

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['rawEvent']['context']['headers']
                .contains('Warning: works'))),
        isTrue);
  });

  testWidgets("sets platform context properties overrides",
      (WidgetTester tester) async {
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'custom-headers',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(
            platformContextProperties: PlatformContextProperties(
          osType: 'osType',
          osVersion: 'osVersion',
          deviceVendor: 'deviceVendor',
          deviceModel: 'deviceModel',
          carrier: 'carrier',
          networkType: NetworkType.wifi,
          networkTechnology: 'networkTechnology',
          appleIdfa: '12345678-1234-1234-1234-123456789012',
          appleIdfv: '22345678-1234-1234-1234-123456789012',
          availableStorage: 1000000,
          totalStorage: 2000000,
          physicalMemory: 3000000,
          appAvailableMemory: 4000000,
          batteryLevel: 99,
          batteryState: BatteryState.full,
          lowPowerMode: true,
          isPortrait: true,
          resolution: '1000x2000',
          scale: 3.5,
          language: 'sk',
          androidIdfa: '32345678-1234-1234-1234-123456789012',
          systemAvailableMemory: 5000000,
          appSetId: '32345678-1234-1234-1234-123456789012',
          appSetIdScope: AppSetIdScope.app,
        )));

    await tracker
        .track(const Structured(category: 'category', action: 'action'));

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length != 1) {
            return false;
          }
          dynamic context = events[0]['event']['contexts']['data'].firstWhere(
              (x) => x['schema'].toString().contains('mobile_context'));

          return (context['data']['osType'] == 'osType') &&
              (context['data']['osVersion'] == 'osVersion') &&
              (context['data']['deviceManufacturer'] == 'deviceVendor') &&
              (context['data']['deviceModel'] == 'deviceModel') &&
              (context['data']['carrier'] == 'carrier') &&
              (context['data']['networkType'] == 'wifi') &&
              (context['data']['networkTechnology'] == 'networkTechnology') &&
              (!Platform.isIOS ||
                  context['data']['appleIdfa'] ==
                      '12345678-1234-1234-1234-123456789012') &&
              (!Platform.isIOS ||
                  context['data']['appleIdfv'] ==
                      '22345678-1234-1234-1234-123456789012') &&
              (context['data']['availableStorage'] == 1000000) &&
              (context['data']['totalStorage'] == 2000000) &&
              (context['data']['physicalMemory'] == 3000000) &&
              (!Platform.isIOS ||
                  context['data']['appAvailableMemory'] == 4000000) &&
              (context['data']['batteryLevel'] == 99) &&
              (context['data']['batteryState'] == 'full') &&
              (!Platform.isIOS || context['data']['lowPowerMode'] == true) &&
              (context['data']['isPortrait'] == true) &&
              (context['data']['resolution'] == '1000x2000') &&
              (context['data']['scale'] == 3.5) &&
              (context['data']['language'] == 'sk') &&
              (!Platform.isAndroid ||
                  context['data']['androidIdfa'] ==
                      '32345678-1234-1234-1234-123456789012') &&
              (!Platform.isAndroid ||
                  context['data']['systemAvailableMemory'] == 5000000) &&
              (!Platform.isAndroid ||
                  context['data']['appSetId'] ==
                      '32345678-1234-1234-1234-123456789012') &&
              (!Platform.isAndroid ||
                  context['data']['appSetIdScope'] == 'app');
        }),
        isTrue);
  });
}
