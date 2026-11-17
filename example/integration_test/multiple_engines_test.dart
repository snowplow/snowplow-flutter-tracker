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
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';

import 'helpers.dart';

const _engines = MethodChannel('snowplow_tracker_example/engines');

/// Runs in the secondary engine, which has the plugin registered but never
/// uses Snowplow, like an app's background engine.
@pragma('vm:entry-point')
void secondaryEngineMain() {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final skip = kIsWeb || defaultTargetPlatform != TargetPlatform.android;
  final List<InspectableEvent> events = [];
  SnowplowTracker? tracker;

  Future<void> waitForEvent(String category) async {
    for (int i = 0; i < 50; i++) {
      if (events.any((e) => e.payload['se_ca'] == category)) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    throw StateError('No afterTrack call for the "$category" event');
  }

  setUpAll(() async {
    if (skip) {
      return;
    }
    tracker = await Snowplow.createTracker(
        namespace: 'engines',
        endpoint: SnowplowTests.microEndpoint,
        plugins: [
          PluginConfiguration(identifier: 'recorder', afterTrack: events.add)
        ]);
  });

  setUp(() {
    events.clear();
  });

  tearDown(() async {
    if (!skip) {
      await _engines.invokeMethod('destroySecondaryEngine');
    }
  });

  testWidgets('calls afterTrack while a secondary engine runs',
      (WidgetTester tester) async {
    await _engines.invokeMethod('startSecondaryEngine', 'secondaryEngineMain');

    await tracker
        ?.track(const Structured(category: 'secondary-running', action: 'a'));
    await waitForEvent('secondary-running');
  }, skip: skip);

  testWidgets('calls afterTrack after a secondary engine is destroyed',
      (WidgetTester tester) async {
    await _engines.invokeMethod('startSecondaryEngine', 'secondaryEngineMain');
    await _engines.invokeMethod('destroySecondaryEngine');

    await tracker
        ?.track(const Structured(category: 'secondary-destroyed', action: 'a'));
    await waitForEvent('secondary-destroyed');
  }, skip: skip);
}
