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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:snowplow_tracker/events/event.dart';
import 'package:snowplow_tracker/events/self_describing.dart';
import 'package:snowplow_tracker/snowplow.dart';
import 'package:snowplow_tracker/snowplow_observer.dart';
import 'package:snowplow_tracker/configurations/configuration.dart';

/// Instance of an initialized Snowplow tracker identified by a [namespace].
///
/// {@category Getting started}
class SnowplowTracker {
  /// Tracker configuration.
  final Configuration configuration;

  const SnowplowTracker({required this.configuration});

  /// Tracks the given event with optional context entities.
  Future<void> track(Event event, {List<SelfDescribing>? contexts}) async {
    await Snowplow.track(event, tracker: namespace, contexts: contexts);
  }

  /// Sets the business user ID to the string.
  Future<void> setUserId(String? userId) async {
    await Snowplow.setUserId(userId, tracker: namespace);
  }

  /// Returns the identifier (string UUIDv4) for the user of the session.
  ///
  /// All trackers on Web share the same session.
  Future<String?> get sessionUserId async {
    return await Snowplow.getSessionUserId(tracker: namespace);
  }

  /// Returns the identifier (string UUIDv4) for the session.
  ///
  /// All trackers on Web share the same session.
  Future<String?> get sessionId async {
    return await Snowplow.getSessionId(tracker: namespace);
  }

  /// Returns the index (number) of the current session for this user.
  ///
  /// All trackers on Web share the same session.
  Future<int?> get sessionIndex async {
    return await Snowplow.getSessionIndex(tracker: namespace);
  }

  /// Returns a [SnowplowObserver] for automatically tracking `PageViewEvent`
  /// and `ScreenView` events from a navigator when the currently active
  /// [ModalRoute] of the navigator changes.
  ///
  /// `ScreenView` events are tracked on all platforms. Optionally,
  /// `PageViewEvent` events may be tracked on Web if
  /// `TrackerConfiguration.webActivityTracking` is configured when creating
  /// the tracker.
  ///
  /// The [nameExtractor] function is used to extract a name
  /// from [RouteSettings] of the now active route and that name is used in
  /// tracked `ScreenView` or `PageViewEvent` events.
  ///
  /// The following operations will result in tracking a view event:
  ///
  /// ```dart
  /// Navigator.pushNamed(context, '/contact/123');
  ///
  /// Navigator.push<void>(context, MaterialPageRoute(
  ///   settings: RouteSettings(name: '/contact/123'),
  ///   builder: (_) => ContactDetail(123)));
  ///
  /// Navigator.pushReplacement<void>(context, MaterialPageRoute(
  ///   settings: RouteSettings(name: '/contact/123'),
  ///   builder: (_) => ContactDetail(123)));
  ///
  /// Navigator.pop(context);
  /// ```
  ///
  /// If using [MaterialApp], add the retrieved observer to
  /// `navigatorObservers`, e.g.:
  ///
  /// ```dart
  /// MaterialApp(
  ///   navigatorObservers: [
  ///     tracker.getObserver()
  ///   ],
  ///   ...
  /// );
  /// ```
  ///
  /// If using the `Router` API with the `MaterialApp.router` constructor,
  /// add the observer to the `observers` of your [Navigator] instance, e.g.:
  ///
  /// ```dart
  /// return Navigator(
  ///   observers: [tracker.getObserver()],
  ///   ...
  /// );
  /// ```
  ///
  /// You can also trigger view event tracking within your [ModalRoute] by implementing
  /// [RouteAware<ModalRoute<dynamic>>] and subscribing it to [SnowplowObserver].
  /// See the [RouteObserver<ModalRoute<dynamic>>] docs for an example.
  SnowplowObserver getObserver(
      {ScreenNameExtractor nameExtractor = defaultNameExtractor}) {
    return SnowplowObserver(tracker: this, nameExtractor: nameExtractor);
  }

  /// Namespace that identifies the tracker.
  String get namespace {
    return configuration.namespace;
  }

  /// Returns true if current platform is Web and `PageViewEvent` tracking is
  /// enabled in `trackerConfig.webActivityTracking` configuration.
  ///
  /// Indicates whether page view events will be tracked in any initialized
  /// observers. If false, screen view events will be tracked.
  bool get tracksPageViews {
    return kIsWeb &&
        (configuration
                .trackerConfig?.webActivityTracking?.trackPageViewsInObserver ??
            false);
  }
}
