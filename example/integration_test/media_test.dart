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

import 'package:snowplow_tracker/events/self_describing.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await SnowplowTests.createTracker();
  });

  setUp(() async {
    await SnowplowTests.resetMicro();
  });

  tearDown(() async {
    await Snowplow.endMediaTracking(tracker: "test", id: "media_id");
  });

  testWidgets("tracks a ready event with the player information",
      (WidgetTester tester) async {
    MediaTracking mediaTracking = await Snowplow.startMediaTracking(
        tracker: "test",
        configuration: const MediaTrackingConfiguration(
            id: "media_id",
            player: MediaPlayerEntity(
              duration: 100,
              label: "My Label",
            )));
    await mediaTracking.track(MediaReadyEvent());

    expect(
        await SnowplowTests.checkMicroCounts(
            (body) => (body['good'] == 1) && (body['bad'] == 0)),
        isTrue);
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length != 1) {
            return false;
          }
          dynamic player = events[0]['event']['contexts']['data'].firstWhere(
              (x) => x['schema'].toString().contains('media_player'));
          dynamic session = events[0]['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('/session/'));
          return ((events[0]['event']['event_name'] == 'ready_event') &&
              (player['data']['label'] == 'My Label') &&
              (player['data']['duration'] == 100) &&
              (session['data']['mediaSessionId'] == 'media_id'));
        }),
        isTrue);
  });

  testWidgets("updates the player information", (WidgetTester tester) async {
    MediaTracking mediaTracking = await Snowplow.startMediaTracking(
        tracker: "test",
        configuration: const MediaTrackingConfiguration(
            id: "media_id", player: MediaPlayerEntity(currentTime: 5)));
    await mediaTracking.track(MediaPlayEvent());
    await mediaTracking.update(
        player: const MediaPlayerEntity(currentTime: 50));
    await mediaTracking.track(MediaPauseEvent());

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length != 2) {
            return false;
          }
          dynamic playEvent = events.firstWhere(
              (event) => event['event']['event_name'] == 'play_event');
          dynamic pauseEvent = events.firstWhere(
              (event) => event['event']['event_name'] == 'pause_event');
          dynamic playPlayer = playEvent['event']['contexts']['data']
              .firstWhere(
                  (x) => x['schema'].toString().contains('media_player'));
          dynamic pausePlayer = pauseEvent['event']['contexts']['data']
              .firstWhere(
                  (x) => x['schema'].toString().contains('media_player'));
          return ((playPlayer['data']['currentTime'] == 5) &&
              (pausePlayer['data']['currentTime'] == 50));
        }),
        isTrue);
  });

  testWidgets("tracks ping events", (WidgetTester tester) async {
    MediaTracking mediaTracking = await Snowplow.startMediaTracking(
        tracker: "test",
        configuration:
            const MediaTrackingConfiguration(id: "media_id", pingInterval: 1));
    await mediaTracking.track(MediaPlayEvent());

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length < 2) {
            return false;
          }
          return (events.firstWhere(
                  (event) => event['event']['event_name'] == 'ping_event') !=
              null);
        }),
        isTrue);
  });

  testWidgets("tracks percent progress event", (WidgetTester tester) async {
    MediaTracking mediaTracking = await Snowplow.startMediaTracking(
        tracker: "test",
        configuration: const MediaTrackingConfiguration(
            id: "media_id",
            player: MediaPlayerEntity(currentTime: 0, duration: 100),
            pings: false,
            boundaries: [50]));
    await mediaTracking.track(MediaPlayEvent());
    await mediaTracking.update(
        player: const MediaPlayerEntity(currentTime: 50));

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length < 2) {
            return false;
          }
          return (events.firstWhere((event) =>
                  event['event']['event_name'] == 'percent_progress_event') !=
              null);
        }),
        isTrue);
  });

  testWidgets("tracks ad events", (WidgetTester tester) async {
    MediaTracking mediaTracking = await Snowplow.startMediaTracking(
        tracker: "test",
        configuration: const MediaTrackingConfiguration(id: "media_id"));
    await mediaTracking.track(MediaPlayEvent());
    await mediaTracking.track(MediaAdBreakStartEvent(),
        adBreak: const MediaAdBreakEntity(breakId: "break-1"));
    await mediaTracking.track(MediaAdStartEvent(),
        ad: const MediaAdEntity(
            adId: "ad-1", creativeId: "creative-1", duration: 3));
    await mediaTracking.track(MediaAdMidpointEvent());
    await mediaTracking.track(MediaAdCompleteEvent());
    await mediaTracking.track(MediaAdBreakEndEvent());
    await mediaTracking.track(MediaEndEvent());

    // ad break start event
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          dynamic event = events.firstWhere(
              (event) => event['event']['event_name'] == 'ad_break_start_event',
              orElse: () => null);
          if (event == null) {
            return false;
          }
          dynamic adBreak = event['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('ad_break'));
          return (adBreak['data']['breakId'] == 'break-1');
        }),
        isTrue);
    // ad start event
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          dynamic event = events.firstWhere(
              (event) => event['event']['event_name'] == 'ad_start_event',
              orElse: () => null);
          if (event == null) {
            return false;
          }
          dynamic ad = event['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('/ad/'));
          event['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('ad_break'));
          return (ad['data']['adId'] == 'ad-1') &&
              (ad['data']['creativeId'] == 'creative-1') &&
              (ad['data']['duration'] == 3);
        }),
        isTrue);
    // ad midpoint event
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          dynamic event = events.firstWhere(
              (event) => event['event']['event_name'] == 'ad_quartile_event',
              orElse: () => null);
          if (event == null) {
            return false;
          }
          event['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('/ad/'));
          event['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('ad_break'));
          return true;
        }),
        isTrue);
    // ad complete event
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          dynamic event = events.firstWhere(
              (event) => event['event']['event_name'] == 'ad_complete_event',
              orElse: () => null);
          if (event == null) {
            return false;
          }
          event['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('/ad/'));
          event['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('ad_break'));
          return true;
        }),
        isTrue);
    // ad break end event
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          dynamic event = events.firstWhere(
              (event) => event['event']['event_name'] == 'ad_break_end_event',
              orElse: () => null);
          if (event == null) {
            return false;
          }
          dynamic adBreak = event['event']['contexts']['data']
              .firstWhere((x) => x['schema'].toString().contains('ad_break'));
          return (adBreak['data']['breakId'] == 'break-1');
        }),
        isTrue);
    // end event
    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          return events.firstWhere(
                  (event) => event['event']['event_name'] == 'end_event',
                  orElse: () => null) !=
              null;
        }),
        isTrue);
  });

  testWidgets("tracks custom context entities", (WidgetTester tester) async {
    MediaTracking mediaTracking = await Snowplow.startMediaTracking(
        tracker: "test",
        configuration:
            const MediaTrackingConfiguration(id: "media_id", contexts: [
          SelfDescribing(
              schema:
                  "iglu:com.snowplowanalytics.iglu/anything-a/jsonschema/1-0-0",
              data: {"key": "value"})
        ]));

    await mediaTracking.track(MediaPlayEvent(), contexts: [
      const SelfDescribing(
          schema: "iglu:com.snowplowanalytics.iglu/anything-b/jsonschema/1-0-0",
          data: {"key": "other_value"})
    ]);

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length < 1) {
            return false;
          }
          dynamic event = events.firstWhere(
              (event) => event['event']['event_name'] == 'play_event');
          event['contexts']
              .firstWhere((x) => x.toString().contains('anything-a'));
          event['contexts']
              .firstWhere((x) => x.toString().contains('anything-b'));
          return true;
        }),
        isTrue);
  });

  testWidgets("tracks a custom event with the media context entities",
      (WidgetTester tester) async {
    MediaTracking mediaTracking = await Snowplow.startMediaTracking(
        tracker: "test",
        configuration: const MediaTrackingConfiguration(
            id: "media_id",
            player: MediaPlayerEntity(
              duration: 100,
              label: "My Label",
            )));

    await mediaTracking.track(const SelfDescribing(
        schema: "iglu:com.snowplowanalytics.iglu/anything-a/jsonschema/1-0-0",
        data: {"key": "other_value"}));

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length < 1) {
            return false;
          }
          dynamic event = events.firstWhere(
              (event) => event['event']['event_name'] == 'anything-a');
          event['contexts']
              .firstWhere((x) => x.toString().contains('media_player'));
          return true;
        }),
        isTrue);
  });
}
