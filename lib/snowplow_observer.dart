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

import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';

/// Signature for a function that extracts view name from [RouteSettings] to be
/// used in `ScreenView` or `PageViewEvent` events tracked in the observer.
typedef ScreenNameExtractor = String? Function(RouteSettings settings);

String? defaultNameExtractor(RouteSettings settings) => settings.name;

/// Route observer that tracks `ScreenView` or `PageViewEvent` events when the
/// currently active [ModalRoute] changes.
///
/// See the documentation in `SnowplowTracker.getObserver` for a more in-depth guide.
class SnowplowObserver extends RouteObserver<ModalRoute<dynamic>> {
  SnowplowObserver(
      {required this.tracker, this.nameExtractor = defaultNameExtractor});

  final ScreenNameExtractor nameExtractor;
  final SnowplowTracker tracker;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _trackRoute(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _trackRoute(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _trackRoute(previousRoute);
    }
  }

  void _trackRoute(PageRoute<dynamic> route) {
    final String? screenName = nameExtractor(route.settings);
    if (tracker.tracksPageViews) {
      tracker.track(PageViewEvent(title: screenName));
    } else {
      if (screenName != null) {
        tracker.track(ScreenView(name: screenName, id: const Uuid().v4()));
      }
    }
  }
}
