import 'package:http/http.dart' as http;

import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'dart:convert';

class SnowplowTests {
  static const microEndpoint = 'http://192.168.100.127:9090';

  static Future<void> createTracker() async {
    await Snowplow.createTracker(namespace: 'test', endpoint: microEndpoint);
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
}
