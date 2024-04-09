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

import 'package:flutter/material.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';
import 'main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// create a Snowplow tracker instance
  final SnowplowTracker tracker = await Snowplow.createTracker(
      namespace: 'ns1',
      endpoint: const String.fromEnvironment('ENDPOINT',
          defaultValue: 'http://0.0.0.0:9090'),
      trackerConfig: const TrackerConfiguration(
          appId: 'demo_app',
          webPageContext: false,
          webActivityTracking:
              WebActivityTracking(minimumVisitLength: 15, heartbeatDelay: 10),
          platformContextProperties: PlatformContextProperties(
            appleIdfa: '12345678-1234-1234-1234-123456789012',
            androidIdfa: '12345678-1234-1234-1234-123456789012',
          ),
          jsMediaPluginURL: 'media.js'),
      gdprConfig: const GdprConfiguration(
          basisForProcessing: 'consent',
          documentId: 'consentDoc-abc123',
          documentVersion: '0.1.0',
          documentDescription:
              'this document describes consent basis for processing'),
      subjectConfig: const SubjectConfiguration(userId: 'XYZ'));
  final MediaTracking mediaTracking = await tracker.startMediaTracking(
      const MediaTrackingConfiguration(id: "demo-media-tracking-id"));

  runApp(MyApp(
    tracker: tracker,
    mediaTracking: mediaTracking,
  ));
}

class MyApp extends StatefulWidget {
  final SnowplowTracker tracker;
  final MediaTracking? mediaTracking;
  const MyApp({
    Key? key,
    required this.tracker,
    this.mediaTracking,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    SnowplowTracker tracker = widget.tracker;
    MediaTracking? mediaTracking = widget.mediaTracking;
    return MaterialApp(
        title: 'Demo App',
        home: MainPage(
          tracker: tracker,
          mediaTracking: mediaTracking,
        ),
        navigatorObservers: [tracker.getObserver()]);
  }
}
