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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:snowplow_tracker/snowplow_tracker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final bool? testing;
  const MyApp({Key? key, this.testing}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MyApp> createState() => _MyAppState(testing: testing);
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  int _numberOfEventsSent = 0;
  String _sessionId = 'Unknown';
  String _sessionUserId = 'Unknown';
  int? _sessionIndex;
  final bool? testing;

  _MyAppState({this.testing}) : super();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (testing == null || testing == false) {
      await Snowplow.createTracker(
          namespace: "ns1",
          endpoint: const String.fromEnvironment('ENDPOINT',
              defaultValue: 'http://0.0.0.0:9090'),
          trackerConfig: const TrackerConfiguration(
              webPageContext: false,
              activityTrackingConfig: ActivityTrackingConfiguration(
                  minimumVisitLength: 15, heartbeatDelay: 10)),
          gdprConfig: const GdprConfiguration(
              basisForProcessing: 'consent',
              documentId: 'consentDoc-abc123',
              documentVersion: '0.1.0',
              documentDescription:
                  'this document describes consent basis for processing'),
          subjectConfig: const SubjectConfiguration(userId: 'XYZ'));
      // await Snowplow.setUserId('XYZ', tracker: 'ns1');
      updateState();
    }

    WidgetsBinding.instance?.addObserver(this);
  }

  Future<void> updateState() async {
    String? sessionId;
    String? sessionUserId;
    int? sessionIndex;

    try {
      sessionId = await Snowplow.getSessionId(tracker: 'ns1') ?? 'Unknown';
      sessionUserId =
          await Snowplow.getSessionUserId(tracker: 'ns1') ?? 'Unknown';
      sessionIndex = await Snowplow.getSessionIndex(tracker: 'ns1');
    } on PlatformException catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }

    if (!mounted) return;

    setState(() {
      _sessionId = sessionId ?? 'Unknown';
      _sessionUserId = sessionUserId ?? 'Unknown';
      _sessionIndex = sessionIndex;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    updateState();
  }

  Future<void> trackEvent(event, {List<SelfDescribing>? contexts}) async {
    Snowplow.track(event, tracker: "ns1", contexts: contexts);

    setState(() {
      _numberOfEventsSent += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: Column(children: <Widget>[
              Text('Number of events sent: $_numberOfEventsSent'),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  const structured = Structured(
                    category: 'shop',
                    action: 'add-to-basket',
                    label: 'Add To Basket',
                    property: 'pcs',
                    value: 2.00,
                  );
                  trackEvent(structured);
                },
                child: const Text('Send Structured Event'),
              ),
              ElevatedButton(
                onPressed: () {
                  const event = SelfDescribing(
                    schema:
                        'iglu:com.snowplowanalytics.snowplow/link_click/jsonschema/1-0-1',
                    data: {'targetUrl': 'http://a-target-url.com'},
                  );
                  trackEvent(event);
                },
                child: const Text('Send Self-Describing Event'),
              ),
              ElevatedButton(
                onPressed: () {
                  const event = ScreenView(
                      id: '2c295365-eae9-4243-a3ee-5c4b7baccc8f',
                      name: 'home',
                      type: 'full',
                      transitionType: 'none');
                  trackEvent(event);
                },
                child: const Text('Send Screen View Event'),
              ),
              ElevatedButton(
                onPressed: () {
                  const event = Timing(
                    category: 'category',
                    variable: 'variable',
                    timing: 1,
                    label: 'label',
                  );
                  trackEvent(event);
                },
                child: const Text('Send Timing Event'),
              ),
              ElevatedButton(
                onPressed: () {
                  final event = ConsentGranted(
                    expiry: DateTime.parse('2021-12-30T09:03:51.196111Z'),
                    documentId: '1234',
                    version: '5',
                    name: 'name1',
                    documentDescription: 'description1',
                  );
                  trackEvent(event);
                },
                child: const Text('Send Consent Granted Event'),
              ),
              ElevatedButton(
                onPressed: () {
                  const event = ConsentWithdrawn(
                    all: false,
                    documentId: '1234',
                    version: '5',
                    name: 'name1',
                    documentDescription: 'description1',
                  );
                  trackEvent(event);
                },
                child: const Text('Send Consent Withdrawn Event'),
              ),
              kIsWeb
                  ? ElevatedButton(
                      onPressed: () {
                        trackEvent(const PageViewEvent());
                      },
                      child: const Text('Send Page View Event'),
                    )
                  : const Text('Page view tracking not available'),
              ElevatedButton(
                onPressed: () {
                  const structured = Structured(
                    category: 'shop',
                    action: 'add-to-basket',
                    label: 'Add To Basket',
                    property: 'pcs',
                    value: 2.00,
                  );
                  trackEvent(structured, contexts: [
                    const SelfDescribing(
                        schema: 'iglu:org.schema/WebPage/jsonschema/1-0-0',
                        data: {
                          'keywords': ['tester']
                        })
                  ]);
                },
                child: const Text('Send Structured Event With Context'),
              ),
              const SizedBox(height: 24.0),
              Text('Session ID: $_sessionId'),
              const SizedBox(height: 5.0),
              Text('Session user ID: $_sessionUserId'),
              const SizedBox(height: 5.0),
              Text('Session index: $_sessionIndex'),
              const SizedBox(height: 5.0)
            ]),
          ),
        ),
      ),
    );
  }
}
