import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:snowplow_tracker/snowplow_tracker.dart';

import 'nested_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    required this.tracker,
    this.mediaTracking,
  });

  final SnowplowTracker tracker;
  final MediaTracking? mediaTracking;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _numberOfEventsSent = 0;
  String _sessionId = 'Unknown';
  String _sessionUserId = 'Unknown';
  int? _sessionIndex;

  Future<void> trackEvent(event, {List<SelfDescribing>? contexts}) async {
    widget.tracker.track(event, contexts: contexts);

    setState(() {
      _numberOfEventsSent += 1;
    });
  }

  Future<void> trackMediaEvent(event, {List<SelfDescribing>? contexts}) async {
    widget.mediaTracking?.track(event, contexts: contexts);

    setState(() {
      _numberOfEventsSent += 1;
    });
  }

  @override
  void initState() {
    super.initState();

    updateState();

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> updateState() async {
    String? sessionId;
    String? sessionUserId;
    int? sessionIndex;

    try {
      sessionId = await widget.tracker.sessionId ?? 'Unknown';
      sessionUserId = await widget.tracker.sessionUserId ?? 'Unknown';
      sessionIndex = await widget.tracker.sessionIndex;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snowplow example app'),
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
                const event = ListItemView(index: 3, itemsCount: 15);
                trackEvent(event);
              },
              child: const Text('Send List Item View Event'),
            ),
            ElevatedButton(
              onPressed: () {
                const event = ScrollChanged(
                  yOffset: 1,
                  xOffset: 2,
                  viewHeight: 20,
                  viewWidth: 10,
                  contentHeight: 100,
                  contentWidth: 200,
                );
                trackEvent(event);
              },
              child: const Text('Send Scroll Changed Event'),
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
            ElevatedButton(
              onPressed: () {
                trackMediaEvent(MediaPlayEvent());
              },
              child: const Text('Send Media Play Event'),
            ),
            ElevatedButton(
              onPressed: () {
                trackMediaEvent(MediaPauseEvent());
              },
              child: const Text('Send Media Pause Event'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<NestedPage>(
              settings: const RouteSettings(name: NestedPage.routeName),
              builder: (BuildContext context) {
                return NestedPage(tracker: widget.tracker);
              },
            ),
          );
        },
        child: const Icon(Icons.help),
      ),
    );
  }
}
