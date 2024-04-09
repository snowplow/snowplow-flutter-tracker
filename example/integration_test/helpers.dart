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

import 'package:http/http.dart' as http;

import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';
import 'dart:convert';

class SnowplowTests {
  static SnowplowTracker? tracker;

  static const microEndpoint =
      String.fromEnvironment('ENDPOINT', defaultValue: 'http://0.0.0.0:9090');

  static Future<void> createTracker() async {
    tracker = await Snowplow.createTracker(
        namespace: 'test',
        endpoint: microEndpoint,
        trackerConfig:
            const TrackerConfiguration(jsMediaPluginURL: "media.js"));
  }

  static Future<void> resetMicro() async {
    await http.get(Uri.parse('$microEndpoint/micro/reset'));
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
    for (int i = 0; i < 10; i++) {
      final response = await http.get(Uri.parse(microEndpoint + api));
      if (validation(jsonDecode(response.body))) {
        return true;
      }
      await Future.delayed(const Duration(seconds: 1), () {});
    }
    return false;
  }
}
