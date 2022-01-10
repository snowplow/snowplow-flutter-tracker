import 'package:http/http.dart' as http;

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
  static const microEndpoint = 'http://192.168.100.127:9090';

  static const MethodChannel _channel =
      MethodChannel('snowplow_flutter_tracker');

  static Future<void> createTracker() async {
    await Snowplow.createTracker(const Configuration(
        namespace: 'test',
        networkConfig: NetworkConfiguration(endpoint: microEndpoint),
        trackerConfig: TrackerConfiguration(
            installAutotracking: false,
            lifecycleAutotracking: false,
            screenViewAutotracking: false),
        emitterConfig: TestEmitterConfiguration()));
  }

  static Future<void> resetMicro() async {
    await http.get(Uri.parse(microEndpoint + '/micro/reset'));
    await Future.delayed(const Duration(seconds: 1), () {});
  }

  static Future<bool> checkMicroCounts(
      bool Function(dynamic body) validation) async {
    return checkMicroResponse('/micro/all', validation);
  }

  static Future<bool> checkMicroGood(
      bool Function(dynamic body) validation) async {
    return checkMicroResponse('/micro/good', validation);
  }

  static Future<bool> checkMicroResponse(
      String api, bool Function(dynamic body) validation) async {
    for (int i = 0; i < 5; i++) {
      final response = await http.get(Uri.parse(microEndpoint + api));
      if (validation(jsonDecode(response.body))) {
        return true;
      }
      await Future.delayed(const Duration(seconds: 1), () {});
    }
    return false;
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
