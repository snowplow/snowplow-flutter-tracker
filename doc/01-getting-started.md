# Getting started

Designing how and what to track in your app is an important decision. Check out our docs about tracking design [here](https://docs.snowplowanalytics.com/docs/understanding-tracking-design/introduction-to-tracking-design/).

The following steps will guide you through setting up the Flutter tracker in your project and tracking a simple event.

## Installation

Add the Snowplow tracker as a dependency to your Flutter application:

```bash
flutter pub add snowplow_flutter_tracker
```

This will add a line with the dependency like to your pubspec.yaml:

```yml
dependencies:
    snowplow_flutter_tracker: ^0.1.0
```

Import the package into your Dart code:

```dart
import 'package:snowplow_flutter_tracker/snowplow_flutter_tracker.dart'
```

## Initialization

Instantiate a tracker using the `Snowplow.createTracker` function.
At its most basic, the function takes two required arguments: `namespace` and `endpoint`.
Tracker namespace identifies the tracker instance, you may create multiple trackers with different namespaces.
The endpoint is the URI of the Snowplow collector to send the events to.

```dart
Tracker tracker = await Snowplow.createTracker(
    namespace: 'ns1',
    endpoint: 'http://...'
);
```

There are additional optional arguments to configure the tracker. To learn more about configuring how events are sent, check out [this page](02-configuration.md).

## Tracking events

To track events, simply instantiate their respective types (e.g., `ScreenView`, `SelfDescribing`, `Structured`) and pass them to the `tracker.track` or `Snowplow.track` methods.

```dart
tracker.track(ScreenView(
    id: '2c295365-eae9-4243-a3ee-5c4b7baccc8f',
    name: 'home',
    type: 'full',
    transitionType: 'none'));
```

Visit documentation about [tracking events](03-tracking-events.md) to learn about other supported event types. You may also want to read about [adding more data to tracked events](04-adding-data.md).

## Testing

Testing that your event tracking is properly configured can be as important as testing the other aspects of your app. It confirms that you are generating the events you expect.

We provide two types of pipeline for testing and debugging. [Snowplow Mini](https://docs.snowplowanalytics.com/docs/understanding-your-pipeline/what-is-snowplow-mini/) is especially useful in manual schema and pipeline testing. [Snowplow Micro](https://docs.snowplowanalytics.com/docs/understanding-your-pipeline/what-is-snowplow-micro/) is a minimal pipeline designed to be used as part of your app's automated test suite.

Check out the [example Flutter app](06-example-app.md) to see the tracker used with a Snowplow Micro.