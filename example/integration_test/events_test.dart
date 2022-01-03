import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'package:snowplow_flutter_tracker/events.dart';

import 'helpers.dart';

void main() {
  setUpAll(() async {
    await SnowplowTests.createTracker();
    sleep(const Duration(seconds: 1));
  });

  setUp(() async {
    await SnowplowTests.removeAllEventStoreEvents(tracker: 'test');
    sleep(const Duration(seconds: 1));
  });

  test("tracks a structured event", () async {
    await Snowplow.track(
        const Structured(category: 'category', action: 'action'),
        tracker: "test");

    sleep(const Duration(seconds: 1));
    var events = await SnowplowTests.getEmittableEvents(tracker: 'test');
    expect(events.length, equals(1));
    var event = events.first;
    expect(event['p'], 'mob');
    expect(event['e'], 'se');
    expect(event['se_ca'], 'category');
    expect(event['se_ac'], 'action');
  });

  test("tracks a self-describing event", () async {
    const selfDescribing = SelfDescribing(
      schema: 'iglu:com.snowplowanalytics.snowplow/link_click/jsonschema/1-0-1',
      data: {'targetUrl': 'http://a-target-url.com'},
    );
    await Snowplow.track(selfDescribing, tracker: "test");

    sleep(const Duration(seconds: 1));
    var events = await SnowplowTests.getEmittableEvents(tracker: 'test');
    expect(events.length, equals(1));
    var event = events.first;

    var json = decodeSelfDescribingEventContent(event);
    expect(json['data']['schema'],
        'iglu:com.snowplowanalytics.snowplow/link_click/jsonschema/1-0-1');
    expect(json['data']['data']['targetUrl'], 'http://a-target-url.com');
  });
}
