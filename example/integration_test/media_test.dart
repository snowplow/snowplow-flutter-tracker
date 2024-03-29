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

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:snowplow_tracker/configurations/media_tracking_configuration.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers.dart';
import 'package:snowplow_tracker_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await SnowplowTests.createTracker();
  });

  setUp(() async {
    await SnowplowTests.resetMicro();
  });

  testWidgets("tracks a ready event", (WidgetTester tester) async {
    MediaTracking mediaTracking = await Snowplow.startMediaTracking(
        tracker: "test",
        configuration: const MediaTrackingConfiguration(
          id: "media_id",
        ));
    await mediaTracking.track(MediaReadyEvent());

    expect(
        await SnowplowTests.checkMicroCounts(
            (body) => (body['good'] == 1) && (body['bad'] == 0)),
        isTrue);
    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['event_name'] == 'ready_event')),
        isTrue);
  });
}
