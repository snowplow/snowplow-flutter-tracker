# Flutter Analytics for Snowplow

[![early-release]][tracker-classificiation]
[![Build Status][gh-actions-image]][gh-actions]
[![Release][release-image]][releases]
[![License][license-image]][license]

Snowplow is a scalable open-source platform for rich, high quality, low-latency data collection. It is designed to collect high quality, complete behavioral data for enterprise business.

**To find out more, please check out the [Snowplow website][website] and our [documentation][docs].**

## Snowplow Flutter Tracker Overview

The Snowplow Flutter Tracker allows you to add analytics to your Flutter apps when using a [Snowplow][snowplow] pipeline.

With this tracker you can collect granular event-level data as your users interact with your Flutter applications.
It is build on top of Snowplow's native [iOS](https://github.com/snowplow/snowplow-objc-tracker) and [Android](https://github.com/snowplow/snowplow-android-tracker) and [web](https://github.com/snowplow/snowplow-javascript-tracker) trackers, in order to support the full range of out-of-the-box Snowplow events and tracking capabilities.

**Technical documentation can be found for each tracker in our [Documentation][flutter-docs].**

## Features

| Feature                                                                                                      | Android | iOS | Web    |
|--------------------------------------------------------------------------------------------------------------|---|---|--------|
| Manual tracking of events: screen views, self-describing, structured, timing, consent granted and withdrawal | ✔ | ✔ | ✔      |
| Automatic tracking of views events from Navigator API                                                        | ✔ | ✔ | ✔      |
| Adding custom context entities to events                                                                     | ✔ | ✔ | ✔      |
| Support for multiple trackers                                                                                | ✔ | ✔ | ✔      |
| Configurable subject properties                                                                              | ✔ | ✔ | partly |
| Session context entity added to events                                                                       | ✔ | ✔ | ✔      |
| Geo-location context entity                                                                                  | ✔ | ✔ | ✔      |
| Mobile platform context entity                                                                               | ✔ | ✔ |        |
| Web page context entity                                                                                      |   |   | ✔      |
| Configurable GDPR context entity                                                                             | ✔ | ✔ | ✔      |
| Lifecycle autotracking                                                                                       | ✔ | ✔ |        |
| Engagement tracking (activity tracking on Web, mobile screen engagement on mobile)                           | ✔ | ✔ | ✔      |

## Quick Start

### Installation

Add the Snowplow tracker as a dependency to your Flutter application:

```bash
flutter pub add snowplow_tracker
```

This will add a line with the dependency like this to your `pubspec.yaml`:

```yml
dependencies:
    snowplow_tracker: ^0.5.0
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

// Tracking a page view event – only supported on the Web
tracker.track(PageView(title: 'Page Title'));

// Tracking a self-describing event
tracker.track(SelfDescribing(
    schema: 'iglu:com.snowplowanalytics.snowplow/link_click/jsonschema/1-0-1',
    data: {'targetUrl': 'http://a-target-url.com'}
));

// Tracking a structured event
tracker.track(Structured(
    category: 'shop',
    action: 'add-to-basket',
    label: 'Add To Basket',
    property: 'pcs',
    value: 2.00,
));

// Tracking an event using the Snowplow interface and tracker namespace
Snowplow.track(
    Structured(category: 'shop', action: 'add-to-basket'),
    tracker: 'ns1' // namespace of initialized tracker
);

// Adding context to an event
tracker.track(
    Structured(category: 'shop', action: 'add-to-basket'),
    contexts: [
        const SelfDescribing(
            schema: 'iglu:org.schema/WebPage/jsonschema/1-0-0',
            data: {'keywords': ['tester']}
        )
    ]);
```

## Find Out More

| Technical Docs                    | Setup Guide                 |
|-----------------------------------|-----------------------------|
| [![i1][techdocs-image]][techdocs] | [![i2][setup-image]][setup] |
| [Technical Docs][techdocs]        | [Setup Guide][setup]        |

## Maintainers

| Contributing                                 |
|----------------------------------------------|
| [![i4][contributing-image]](CONTRIBUTING.md) |
| [Contributing](CONTRIBUTING.md)              |

### Maintainer Quick Start

Assuming [Flutter SDK](https://docs.flutter.dev/get-started/install) is set up and [Snowplow Micro](https://github.com/snowplow-incubator/snowplow-micro) is running on your computer.

#### Clone Repository

```bash
git clone https://github.com/snowplow/snowplow-flutter-tracker.git
```

## Example App

The tracker comes with a demo app that shows it in use.
It is a simple app with list of buttons for triggering different types of events.
The project is located in the `example` subfolder.

Running the example app on Android/iOS:

1. Change into the project folder and `cd example`
2. Run the app (replace the Snowplow Micro URI with your IP address and set your iPhone or Android simulator name or remove to use default):

```bash
flutter run --dart-define=ENDPOINT=http://192.168.100.127:9090 -d "iPhone 13 Pro"
```

To run the example app on Web:

1. [Download ChromeDriver](https://chromedriver.chromium.org/downloads) and launch it using `chromedriver --port=4444`
2. Change into the project folder and `cd example`
3. Run the app (replace the Snowplow Micro URI with your IP address):

```bash
flutter run --dart-define=ENDPOINT=http://0.0.0.0:9090 -d Chrome
```

Alternatively, if you use Visual Studio Code you may also run the example app using the "Run Example App" target (update your IP address in .vscode/launch.json).

## Testing

The tracker functionality is verified using unit and integration tests.
Unit tests test individual components of the tracker in isolation and do not make any external network requests.
Integration tests use a Snowplow Micro instance to verify end-to-end tracking of events.

The unit tests are located in the `tests` subfolder in the root of the project.
Having installed the Flutter SDK, run the tests using `flutter test` (or run them directly from Visual Studio Code).

The integration tests are located in the `example/integration_test` subfolder.
These tests make use of the example app to provide end-to-end testing of the tracker.

Running the integration tests on Android/iOS:

1. Change into the project folder and `cd example`
2. Run the integration tests (replace the Snowplow Micro URI with your IP address and set your iPhone or Android simulator name or remove to use default):

```bash
flutter test integration_test --dart-define=ENDPOINT=http://192.168.100.127:9090 -d "iPhone 13 Pro"
```

Alternatively, you may also run the integration tests directly from Visual Studio Code.

To run the integration tests on Web:

1. [Download ChromeDriver](https://chromedriver.chromium.org/downloads) and launch it using `chromedriver --port=4444`
2. Change into the project folder and `cd example`
3. Run the integration tests (replace the Snowplow Micro URI with your IP address):

```bash
./tool/e2e_tests.sh http://0.0.0.0:9090 "-d web-server"
```

## Copyright and License

The Snowplow Flutter Tracker is copyright 2022-present Snowplow Analytics Ltd.

Licensed under the **[Apache License, Version 2.0][license]** (the "License");
you may not use this software except in compliance with the License.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[website]: https://snowplowanalytics.com
[snowplow]: https://github.com/snowplow/snowplow
[docs]: https://docs.snowplow.io/
[flutter-docs]: https://docs.snowplow.io/docs/collecting-data/collecting-from-own-applications/flutter-tracker/

[gh-actions]: https://github.com/snowplow/snowplow-flutter-tracker/actions/workflows/build.yml
[gh-actions-image]: https://github.com/snowplow/snowplow-flutter-tracker/actions/workflows/build.yml/badge.svg

[license]: https://www.apache.org/licenses/LICENSE-2.0
[license-image]: https://img.shields.io/badge/license-Apache--2-blue.svg?style=flat

[release-image]: https://img.shields.io/pub/v/snowplow_tracker
[releases]: https://pub.dev/packages/snowplow_tracker

[techdocs]: https://docs.snowplow.io/docs/collecting-data/collecting-from-own-applications/flutter-tracker/
[techdocs-image]: https://d3i6fms1cm1j0i.cloudfront.net/github/images/techdocs.png
[setup]: https://docs.snowplow.io/docs/collecting-data/collecting-from-own-applications/flutter-tracker/quick-start-guide
[setup-image]: https://d3i6fms1cm1j0i.cloudfront.net/github/images/setup.png

[api-docs]: https://snowplow.github.io/snowplow-flutter-tracker/

[contributing-image]: https://d3i6fms1cm1j0i.cloudfront.net/github/images/contributing.png

[tracker-classificiation]: https://github.com/snowplow/snowplow/wiki/Tracker-Maintenance-Classification
[early-release]: https://img.shields.io/static/v1?style=flat&label=Snowplow&message=Early%20Release&color=014477&labelColor=9ba0aa&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAeFBMVEVMaXGXANeYANeXANZbAJmXANeUANSQAM+XANeMAMpaAJhZAJeZANiXANaXANaOAM2WANVnAKWXANZ9ALtmAKVaAJmXANZaAJlXAJZdAJxaAJlZAJdbAJlbAJmQAM+UANKZANhhAJ+EAL+BAL9oAKZnAKVjAKF1ALNBd8J1AAAAKHRSTlMAa1hWXyteBTQJIEwRgUh2JjJon21wcBgNfmc+JlOBQjwezWF2l5dXzkW3/wAAAHpJREFUeNokhQOCA1EAxTL85hi7dXv/E5YPCYBq5DeN4pcqV1XbtW/xTVMIMAZE0cBHEaZhBmIQwCFofeprPUHqjmD/+7peztd62dWQRkvrQayXkn01f/gWp2CrxfjY7rcZ5V7DEMDQgmEozFpZqLUYDsNwOqbnMLwPAJEwCopZxKttAAAAAElFTkSuQmCC
