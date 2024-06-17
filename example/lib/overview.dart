import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Markdown(
      data:
          '''The Snowplow Flutter Tracker allows you to add analytics to your Flutter apps when using a [Snowplow](https://github.com/snowplow/snowplow) pipeline.

With this tracker you can collect granular event-level data as your users interact with your Flutter applications.
It is build on top of Snowplow's native [iOS](https://github.com/snowplow/snowplow-objc-tracker) and [Android](https://github.com/snowplow/snowplow-android-tracker) and [web](https://github.com/snowplow/snowplow-javascript-tracker) trackers, in order to support the full range of out-of-the-box Snowplow events and tracking capabilities.

## Quick Start

### Installation

Add the Snowplow tracker as a dependency to your Flutter application:

```bash
flutter pub add snowplow_tracker
```

This will add a line with the dependency like this to your `pubspec.yaml`:

```yml
dependencies:
    snowplow_tracker: ^0.7.1
```

Import the package into your Dart code:

```dart
import 'package:snowplow_tracker/snowplow_tracker.dart'
```

#### Installation on Web

If using the tracker within a Flutter app for Web, you will also need to import the Snowplow JavaScript Tracker in your `index.html` file. Please load the JS tracker with the Snowplow tag as [described in the official documentation](https://docs.snowplow.io/docs/collecting-data/collecting-from-own-applications/javascript-trackers/javascript-tracker/javascript-tracker-v3/tracker-setup/loading/). Do not change the global function name `snowplow` that is used to access the tracker – the Flutter APIs assume that it remains the default as shown in documentation.

Make sure to use JavaScript tracker version `3.5` or newer. You may also refer to the [example project](https://github.com/snowplow/snowplow-flutter-tracker/tree/main/example) in the Flutter tracker repository to see this in action.

### Using the Tracker

Instantiate a tracker using the `Snowplow.createTracker` function.
You may create the tracker in the `initState()` of your main widget.
The function takes two required arguments: `namespace` and `endpoint`.
Tracker namespace identifies the tracker instance; you may create multiple trackers with different namespaces.
The endpoint is the URI of the Snowplow collector to send the events to.
There are additional optional arguments to configure the tracker, please refer to the documentation for a complete specification.

```dart
SnowplowTracker tracker = await Snowplow.createTracker(
    namespace: 'ns1',
    endpoint: 'http://...'
);
```

To track events, simply instantiate their respective types (e.g., `ScreenView`, `SelfDescribing`, `Structured`) and pass them to the `tracker.track` or `Snowplow.track` methods.
Please refer to the documentation for specification of event properties.

```dart
// Tracking a screen view event
tracker.track(ScreenView(
    id: '2c295365-eae9-4243-a3ee-5c4b7baccc8f',
    name: 'home',
    type: 'full',
    transitionType: 'none'));
''',
    );
  }
}
