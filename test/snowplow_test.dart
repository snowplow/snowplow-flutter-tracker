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
import 'package:snowplow_tracker/configurations/gdpr_configuration.dart';
import 'package:snowplow_tracker/configurations/tracker_configuration.dart';
import 'package:snowplow_tracker/events/consent_granted.dart';
import 'package:snowplow_tracker/events/consent_withdrawn.dart';
import 'package:snowplow_tracker/events/event.dart';
import 'package:snowplow_tracker/events/screen_view.dart';
import 'package:snowplow_tracker/events/self_describing.dart';
import 'package:snowplow_tracker/events/structured.dart';
import 'package:snowplow_tracker/events/timing.dart';
import 'package:snowplow_tracker/events/page_view_event.dart';
import 'package:snowplow_tracker/snowplow.dart';
import 'package:uuid/uuid.dart';

void main() {
  const MethodChannel channel = MethodChannel('snowplow_tracker');
  MethodCall? methodCall;
  dynamic returnValue;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    methodCall = null;
    returnValue = null;
    channel.setMockMethodCallHandler((MethodCall call) async {
      methodCall = call;
      return returnValue;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('createsTrackerWithConfiguration', () async {
    await Snowplow.createTracker(
        namespace: 'tns1',
        endpoint: 'https://snowplowanalytics.com',
        trackerConfig: const TrackerConfiguration(
            devicePlatform: DevicePlatform.iot, base64Encoding: true),
        gdprConfig: const GdprConfiguration(
            basisForProcessing: 'b',
            documentId: 'd',
            documentVersion: 'v',
            documentDescription: 'e'));

    expect(
        methodCall,
        isMethodCall('createTracker', arguments: {
          'namespace': 'tns1',
          'networkConfig': {'endpoint': 'https://snowplowanalytics.com'},
          'trackerConfig': {'devicePlatform': 'iot', 'base64Encoding': true},
          'gdprConfig': {
            'basisForProcessing': 'b',
            'documentId': 'd',
            'documentVersion': 'v',
            'documentDescription': 'e',
          }
        }));
  });

  test('tracks structured event', () async {
    Event event = const Structured(category: 'c1', action: 'a1');
    await Snowplow.track(event, tracker: 'tns3');

    expect(
        methodCall,
        isMethodCall('trackStructured', arguments: {
          'tracker': 'tns3',
          'eventData': {'category': 'c1', 'action': 'a1'}
        }));
  });

  test('tracks structured event with context', () async {
    Event event = const Structured(category: 'c1', action: 'a1');
    await Snowplow.track(event, tracker: 'tns3', contexts: [
      const SelfDescribing(schema: 'schema://schema1', data: {'x': 'y'})
    ]);

    expect(
        methodCall,
        isMethodCall('trackStructured', arguments: {
          'tracker': 'tns3',
          'eventData': {'category': 'c1', 'action': 'a1'},
          'contexts': [
            {
              'schema': 'schema://schema1',
              'data': {'x': 'y'}
            }
          ]
        }));
  });

  test('tracks self-describing event', () async {
    Event event =
        const SelfDescribing(schema: 'schema://schema2', data: {'y': 'z'});
    await Snowplow.track(event, tracker: 'tns2');

    expect(
        methodCall,
        isMethodCall('trackSelfDescribing', arguments: {
          'tracker': 'tns2',
          'eventData': {
            'schema': 'schema://schema2',
            'data': {'y': 'z'}
          }
        }));
  });

  test('tracks screen view event', () async {
    String id = const Uuid().v4();
    Event event = ScreenView(name: 'screen1', id: id);
    await Snowplow.track(event, tracker: 'tns2');

    expect(
        methodCall,
        isMethodCall('trackScreenView', arguments: {
          'tracker': 'tns2',
          'eventData': {'name': 'screen1', 'id': id}
        }));
  });

  test('tracks timing event', () async {
    Event event = const Timing(category: 'c1', variable: 'v1', timing: 34);
    await Snowplow.track(event, tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('trackTiming', arguments: {
          'tracker': 'tns1',
          'eventData': {'category': 'c1', 'variable': 'v1', 'timing': 34}
        }));
  });

  test('tracks consent granted event', () async {
    Event event = ConsentGranted(
      expiry: DateTime.parse('2021-12-30T09:03:51.196Z'),
      documentId: 'd1',
      version: '10',
    );
    await Snowplow.track(event, tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('trackConsentGranted', arguments: {
          'tracker': 'tns1',
          'eventData': {
            'expiry': '2021-12-30T09:03:51.196Z',
            'documentId': 'd1',
            'version': '10'
          }
        }));
  });

  test('tracks consent withdrawn event', () async {
    Event event = const ConsentWithdrawn(
      all: true,
      documentId: 'd1',
      version: '10',
    );
    await Snowplow.track(event, tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('trackConsentWithdrawn', arguments: {
          'tracker': 'tns1',
          'eventData': {'all': true, 'documentId': 'd1', 'version': '10'}
        }));
  });

  test('tracks page view event', () async {
    Event event = const PageViewEvent(
      title: 'pageTitle',
    );
    await Snowplow.track(event, tracker: 'ns1');

    expect(
        methodCall,
        isMethodCall('trackPageView', arguments: {
          'tracker': 'ns1',
          'eventData': {'title': 'pageTitle'}
        }));
  });

  test('sets user ID', () async {
    await Snowplow.setUserId('u1', tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('setUserId',
            arguments: {'tracker': 'tns1', 'userId': 'u1'}));
  });

  test('gets session user ID', () async {
    returnValue = 'u1';
    String? sessionUserId = await Snowplow.getSessionUserId(tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('getSessionUserId', arguments: {
          'tracker': 'tns1',
        }));
    expect(sessionUserId, equals('u1'));
  });

  test('gets session ID', () async {
    returnValue = 's1';
    String? sessionId = await Snowplow.getSessionId(tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('getSessionId', arguments: {
          'tracker': 'tns1',
        }));
    expect(sessionId, equals('s1'));
  });

  test('gets session index', () async {
    returnValue = 10;
    int? sessionIndex = await Snowplow.getSessionIndex(tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('getSessionIndex', arguments: {
          'tracker': 'tns1',
        }));
    expect(sessionIndex, equals(10));
  });
}
