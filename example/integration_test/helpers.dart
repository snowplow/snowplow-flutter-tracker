import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/configurations.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'dart:convert';

class TestEmitterConfiguration extends EmitterConfiguration {
  const TestEmitterConfiguration() : super(bufferOption: 'single');

  @override
  Map<String, Object?> toMap() {
    var map = super.toMap();
    map['mockEventStore'] = true;
    return map;
  }
}

class SnowplowTests {
  static const MethodChannel _channel =
      MethodChannel('snowplow_flutter_tracker');

  static Future<void> createTracker() async {
    await Snowplow.createTracker(const Configuration(
        namespace: 'test',
        networkConfig: NetworkConfiguration(endpoint: 'http://localhost'),
        emitterConfig: TestEmitterConfiguration()));
  }

  static Future<List<Map>> getEmittableEvents({required String tracker}) async {
    Object? response =
        await _channel.invokeMethod('getEmittableEvents', {'tracker': tracker});

    var events = (response! as List).map((e) => e as Map).toList();
    return events;
  }

  static Future<void> removeAllEventStoreEvents(
      {required String tracker}) async {
    await _channel
        .invokeMethod('removeAllEventStoreEvents', {'tracker': tracker});
  }
}

dynamic decodeSelfDescribingEventContent(dynamic event) {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  var content = stringToBase64.decode(event['ue_px']);
  return jsonDecode(content);
}
