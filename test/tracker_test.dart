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

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/events/structured.dart';
import 'package:snowplow_tracker/tracker.dart';
import 'package:snowplow_tracker/snowplow.dart';

void main() {
  const MethodChannel channel = MethodChannel('snowplow_tracker');
  String? method;
  dynamic arguments;
  Tracker? tracker;
  dynamic returnValue;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    returnValue = null;

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      method = methodCall.method;
      arguments = methodCall.arguments;
      return returnValue;
    });

    tracker = Snowplow.createTracker(namespace: 'ns1', endpoint: 'e1');
    method = null;
    arguments = null;
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('tracks structured event', () async {
    await tracker
        ?.track(const Structured(category: 'category', action: 'action'));

    expect(method, equals('trackStructured'));
    expect(arguments['tracker'], equals('ns1'));
    expect(arguments['eventData']['category'], equals('category'));
  });

  test('sets user ID', () async {
    await tracker?.setUserId('XYZ');

    expect(method, equals('setUserId'));
    expect(arguments['tracker'], equals('ns1'));
    expect(arguments['userId'], equals('XYZ'));
  });

  test('gets session ID', () async {
    returnValue = '1234';
    String? sessionId = await tracker?.sessionId;

    expect(method, equals('getSessionId'));
    expect(arguments['tracker'], equals('ns1'));
    expect(sessionId, equals('1234'));
  });
}
