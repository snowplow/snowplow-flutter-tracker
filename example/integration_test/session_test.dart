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

import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/snowplow.dart';
import 'package:snowplow_tracker/events/structured.dart';
import 'package:snowplow_tracker/configurations/tracker_configuration.dart';
import 'package:snowplow_tracker/tracker.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SnowplowTests.createTracker();
  });

  setUp(() async {
    await SnowplowTests.resetMicro();
  });

  testWidgets("maintains the same session context",
      (WidgetTester tester) async {
    await SnowplowTests.tracker
        ?.track(const Structured(category: 'category', action: 'action'));

    dynamic clientSession1;
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length == 0) {
            return false;
          }
          Iterable sessions = events[0]['event']['contexts']['data']
              .where((x) => x['schema'].toString().contains('client_session'));
          if (sessions.length != 1) {
            return false;
          }
          clientSession1 = sessions.first;
          return true;
        }),
        isTrue);

    expect(clientSession1['data']['firstEventId'], isNotNull);
    expect(clientSession1['data']['sessionId'], isNotNull);
    expect(clientSession1['data']['userId'], isNotNull);

    await SnowplowTests.resetMicro();

    await SnowplowTests.tracker
        ?.track(const Structured(category: 'category', action: 'action'));

    dynamic clientSession2;
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length == 0) {
            return false;
          }
          Iterable sessions = events[0]['event']['contexts']['data']
              .where((x) => x['schema'].toString().contains('client_session'));
          if (sessions.length != 1) {
            return false;
          }
          clientSession2 = sessions.first;
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
    await SnowplowTests.tracker
        ?.track(const Structured(category: 'category', action: 'action'));

    dynamic clientSession;
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length != 1) {
            return false;
          }
          Iterable sessions = events[0]['event']['contexts']['data']
              .where((x) => x['schema'].toString().contains('client_session'));
          if (sessions.length != 1) {
            return false;
          }
          clientSession = sessions.first;
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

  testWidgets("doesn't add session context when disabled",
      (WidgetTester tester) async {
    Tracker tracker = Snowplow.createTracker(
        namespace: 'test-without-session',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(sessionContext: false));

    await tracker
        .track(const Structured(category: 'category', action: 'action'));

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length != 1) {
            return false;
          }
          Iterable contexts = events[0]['event']['contexts']['data']
              .where((x) => x['schema'].toString().contains('client_session'));
          return contexts.isEmpty;
        }),
        isTrue);
  });
}
