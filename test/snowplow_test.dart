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

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';

void main() {
  const MethodChannel channel = MethodChannel('snowplow_tracker');
  MethodCall? methodCall;
  dynamic returnValue;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    methodCall = null;
    returnValue = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      methodCall = call;
      return returnValue;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (message) => null);
  });

  test('createsTrackerWithConfiguration', () async {
    await Snowplow.createTracker(
        namespace: 'tns1',
        endpoint: 'https://snowplowanalytics.com',
        trackerConfig: const TrackerConfiguration(
            devicePlatform: DevicePlatform.iot,
            base64Encoding: true,
            screenContext: false,
            applicationContext: true),
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
          'trackerConfig': {
            'devicePlatform': 'iot',
            'base64Encoding': true,
            'screenContext': false,
            'applicationContext': true
          },
          'gdprConfig': {
            'basisForProcessing': 'b',
            'documentId': 'd',
            'documentVersion': 'v',
            'documentDescription': 'e',
          }
        }));
  });

  test('createsTrackerWithCustomPostPath', () async {
    await Snowplow.createTracker(
        namespace: 'tns1',
        endpoint: 'https://snowplowanalytics.com',
        method: Method.post,
        customPostPath: 'com.custom',
        trackerConfig: const TrackerConfiguration(
            devicePlatform: DevicePlatform.iot,
            base64Encoding: true,
            sessionContext: true,
            userAnonymisation: false),
        gdprConfig: const GdprConfiguration(
            basisForProcessing: 'b',
            documentId: 'd',
            documentVersion: 'v',
            documentDescription: 'e'));

    expect(
        methodCall,
        isMethodCall('createTracker', arguments: {
          'namespace': 'tns1',
          'networkConfig': {
            'endpoint': 'https://snowplowanalytics.com',
            'method': 'post',
            'customPostPath': 'com.custom'
          },
          'trackerConfig': {
            'devicePlatform': 'iot',
            'base64Encoding': true,
            'sessionContext': true,
            'userAnonymisation': false
          },
          'gdprConfig': {
            'basisForProcessing': 'b',
            'documentId': 'd',
            'documentVersion': 'v',
            'documentDescription': 'e',
          }
        }));
  });

  test('createsTrackerWithCustomRequestHeaders', () async {
    await Snowplow.createTracker(
        namespace: 'tns1',
        endpoint: 'https://snowplowanalytics.com',
        requestHeaders: {'header1': 'value1', 'header2': 'value2'});

    expect(
        methodCall,
        isMethodCall('createTracker', arguments: {
          'namespace': 'tns1',
          'networkConfig': {
            'endpoint': 'https://snowplowanalytics.com',
            'requestHeaders': {'header1': 'value1', 'header2': 'value2'}
          }
        }));
  });

  test('createsTrackerWithEmitterConfig', () async {
    await Snowplow.createTracker(
        namespace: 'tns1',
        endpoint: 'https://snowplowanalytics.com',
        emitterConfig: const EmitterConfiguration(serverAnonymisation: true));

    expect(
        methodCall,
        isMethodCall('createTracker', arguments: {
          'namespace': 'tns1',
          'networkConfig': {
            'endpoint': 'https://snowplowanalytics.com',
          },
          'emitterConfig': {'serverAnonymisation': true},
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
    Event event = const ScreenView(name: 'screen1');
    await Snowplow.track(event, tracker: 'tns2');

    expect(
        methodCall,
        isMethodCall('trackScreenView', arguments: {
          'tracker': 'tns2',
          'eventData': {'name': 'screen1'}
        }));
  });

  test('tracks scroll changed event', () async {
    Event event = const ScrollChanged(
      yOffset: 10,
      xOffset: 20,
      viewHeight: 100,
      viewWidth: 200,
      contentHeight: 300,
      contentWidth: 400,
    );
    await Snowplow.track(event, tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('trackScrollChanged', arguments: {
          'tracker': 'tns1',
          'eventData': {
            'yOffset': 10,
            'xOffset': 20,
            'viewHeight': 100,
            'viewWidth': 200,
            'contentHeight': 300,
            'contentWidth': 400,
          }
        }));
  });

  test('tracks list item view event', () async {
    Event event = const ListItemView(index: 1, itemsCount: 10);
    await Snowplow.track(event, tracker: 'tns1');

    expect(
        methodCall,
        isMethodCall('trackListItemView', arguments: {
          'tracker': 'tns1',
          'eventData': {
            'index': 1,
            'itemsCount': 10,
          }
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

  test('starts media tracking', () async {
    await Snowplow.startMediaTracking(
        tracker: 'tns1',
        configuration: const MediaTrackingConfiguration(id: 'm1'));

    expect(
        methodCall,
        isMethodCall('startMediaTracking', arguments: {
          'tracker': 'tns1',
          'configuration': {'id': 'm1', 'pings': true, 'session': true}
        }));
  });

  test('updates media tracking', () async {
    await Snowplow.updateMediaTracking(
        tracker: 'tns1',
        id: 'm1',
        player: const MediaPlayerEntity(
            label: 'n1', currentTime: 10, duration: 100, volume: 50),
        ad: const MediaAdEntity(adId: "ad1"));

    expect(
        methodCall,
        isMethodCall('updateMediaTracking', arguments: {
          'tracker': 'tns1',
          'mediaTrackingId': 'm1',
          'player': {
            'label': 'n1',
            'currentTime': 10.0,
            'duration': 100.0,
            'volume': 50
          },
          'ad': {'adId': 'ad1'},
          'adBreak': null
        }));
  });

  test('ends media tracking', () async {
    await Snowplow.endMediaTracking(tracker: 'tns1', id: 'm1');

    expect(
        methodCall,
        isMethodCall('endMediaTracking', arguments: {
          'tracker': 'tns1',
          'mediaTrackingId': 'm1',
        }));
  });
}
