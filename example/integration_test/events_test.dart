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
import 'package:flutter/services.dart';
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

  testWidgets("tracks a structured event", (WidgetTester tester) async {
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

  testWidgets("tracks a screen view event", (WidgetTester tester) async {
    String id = const Uuid().v4();

    var screenView = ScreenView(id: id, name: 'name');
    await Snowplow.track(screenView, tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['data']['id']
                    .toLowerCase() ==
                id.toLowerCase()) &&
            (events[0]['event']['unstruct_event']['data']['data']['name'] ==
                'name')),
        isTrue);
  });

  testWidgets(
      "tracks screen summary using the list item view and scroll changed events",
      (WidgetTester tester) async {
    // screen engagement events are not available on web
    if (kIsWeb) {
      return;
    }

    // first screen view
    await Snowplow.track(ScreenView(name: "s1", id: const Uuid().v4()),
        tracker: 'test');

    // screen engagement events
    await Snowplow.track(const ListItemView(index: 2, itemsCount: 15),
        tracker: 'test');
    await Snowplow.track(
        const ScrollChanged(yOffset: 1, viewHeight: 10, contentHeight: 100),
        tracker: 'test');

    // second screen view
    await Snowplow.track(ScreenView(name: "s2", id: const Uuid().v4()),
        tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) {
          dynamic event = events.firstWhere(
              (event) =>
                  event['event']['event_name'] == 'screen_end' &&
                  event['event']['contexts']['data'].firstWhere((x) =>
                          x['schema']
                              .toString()
                              .contains('screen/'))['data']['name'] ==
                      's1',
              orElse: () => null);
          if (event == null) {
            return false;
          }
          dynamic context = event['event']['contexts']['data'].firstWhere(
              (x) => x['schema'].toString().contains('screen_summary'));
          return context['data']['min_y_offset'] == 1 &&
              context['data']['max_y_offset'] == 11 &&
              context['data']['content_height'] == 100 &&
              context['data']['items_count'] == 15 &&
              context['data']['last_item_index'] == 2;
        }),
        isTrue);
  });

  testWidgets("tracks a timing event", (WidgetTester tester) async {
    var timing =
        const Timing(category: 'cat', variable: 'var', timing: 10, label: 'l');
    await Snowplow.track(timing, tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['data']['category'] ==
                'cat') &&
            (events[0]['event']['unstruct_event']['data']['data']['timing'] ==
                10)),
        isTrue);
  });

  testWidgets("tracks a consent granted event", (WidgetTester tester) async {
    final consentGranted = ConsentGranted(
      expiry: DateTime.parse('2021-12-30T09:03:51.196Z'),
      documentId: '1234',
      version: '5',
      name: 'name1',
      documentDescription: 'description1',
    );
    await Snowplow.track(consentGranted, tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['data']['expiry'] ==
                '2021-12-30T09:03:51.196Z')),
        isTrue);
  });

  testWidgets("tracks a consent withdrawn event", (WidgetTester tester) async {
    const consentWithdrawn = ConsentWithdrawn(
      all: false,
      documentId: '1234',
      version: '5',
      name: 'name1',
      documentDescription: 'description1',
    );
    await Snowplow.track(consentWithdrawn, tracker: 'test');

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['unstruct_event']['data']['data']['all'] ==
                false)),
        isTrue);
  });

  testWidgets("tracks an event with custom context",
      (WidgetTester tester) async {
    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: "test",
        contexts: [
          const SelfDescribing(
              schema:
                  'iglu:com.snowplowanalytics.snowplow/media_player/jsonschema/1-0-0',
              data: {
                'currentTime': 0,
                'duration': 10,
                'ended': false,
                'loop': false,
                'muted': false,
                'paused': false,
                'playbackRate': 1,
                'volume': 100
              })
        ]);

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          if (events.length != 1) {
            return false;
          }
          dynamic context = events[0]['event']['contexts']['data'].firstWhere(
              (x) => x['schema'].toString().contains('media_player'));
          return context['data']['volume'] == 100;
        }),
        isTrue);
  });

  testWidgets(
      "tracks a page view event on web after loading page if web activity tracking",
      (WidgetTester tester) async {
    if (!kIsWeb) {
      return;
    }
    SnowplowTracker tracker = await Snowplow.createTracker(
        namespace: 'web',
        endpoint: SnowplowTests.microEndpoint,
        trackerConfig: const TrackerConfiguration(
            webActivityTracking: WebActivityTracking()));
    await tester.pumpWidget(MyApp(tracker: tracker));

    expect(
        await SnowplowTests.checkMicroGood((events) =>
            (events.length == 1) &&
            (events[0]['event']['page_title'] == '/') &&
            (events[0]['event']['page_url'] != null) &&
            (events[0]['event']['page_referrer'] != null)),
        isTrue);
  });

  testWidgets("tracks a screen view event after loading page",
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(tracker: SnowplowTests.tracker!));

    expect(
        await SnowplowTests.checkMicroGood((dynamic events) {
          dynamic screenViews = events
              .where((event) => event['event']['event_name'] == 'screen_view');

          return (screenViews.length == 1) &&
              (events[0]['event']['unstruct_event']['data']['data']['name'] ==
                  '/');
        }),
        isTrue);
  });

  testWidgets("raises an exception when tracking page view event on mobile",
      (WidgetTester tester) async {
    if (kIsWeb) {
      return;
    }

    try {
      await Snowplow.track(const PageViewEvent(), tracker: 'test');
      fail('Exception not thrown');
    } catch (e) {
      expect(e, isInstanceOf<MissingPluginException>());
    }
  });
}
