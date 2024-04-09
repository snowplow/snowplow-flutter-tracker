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

import 'package:flutter/foundation.dart';
import 'package:snowplow_tracker/configurations/platform_context_properties.dart';
import 'package:snowplow_tracker/configurations/web_activity_tracking.dart';

/// Configuration of the tracker and the core tracker properties.
///
/// Indicates what should be tracked in terms of automatic tracking and
/// contexts/entities to attach to the events.
/// {@category Sessions and data model}
/// {@category Initialization and configuration}
@immutable
class TrackerConfiguration {
  /// Identifier of the app.
  ///
  /// Defaults to null on Web, product bundle identifier on iOS/Android
  final String? appId;

  /// The device platform the tracker runs on.
  ///
  /// Defaults to "web" on Web and "mob" on iOS/Android
  final DevicePlatform? devicePlatform;

  /// Indicates whether payload JSON data should be base64 encoded.
  ///
  /// Defaults to true.
  final bool? base64Encoding;

  /// Indicates whether platform context should be attached to tracked events.
  ///
  /// Defaults to true on iOS and Android. Not available on Web.
  final bool? platformContext;

  /// Indicates whether geo-location context should be attached to tracked events.
  ///
  /// Defaults to false.
  final bool? geoLocationContext;

  /// Indicates whether session context should be attached to tracked events.
  ///
  /// Defaults to true.
  final bool? sessionContext;

  /// Indicates whether context about current web page should be attached to
  /// tracked events.
  ///
  /// Only available on Web, defaults to true.
  final bool? webPageContext;

  /// Indicates whether screen context should be attached to tracked events.
  ///
  /// Defaults to true on iOS and Android. Not available on Web.
  final bool? screenContext;

  /// Indicates whether application context should be attached to tracked events.
  ///
  /// Defaults to true on iOS and Android. Not available on Web.
  final bool? applicationContext;

  /// Configuration for activity tracking on the Web and use of `PageViewEvent`
  /// events in auto tracking from [SnowplowObserver] observers.
  final WebActivityTracking? webActivityTracking;

  /// Indicates whether user identifiers should be anonymised.
  final bool? userAnonymisation;

  /// Indicates whether to enable automatic tracking of background and foreground transitions.
  ///
  /// Defaults to true on iOS and Android. Not available on Web.
  final bool? lifecycleAutotracking;

  /// Whether to enable tracking of the screen end event and the screen summary context entity.
  ///
  /// Make sure that you have lifecycle autotracking enabled for screen summary to have complete information.
  /// Defaults to true on iOS and Android. Not available on Web.
  final bool? screenEngagementAutotracking;

  /// Overrides for the values for properties of the platform context.
  /// Only available on mobile apps (Android and iOS), not on Web.
  final PlatformContextProperties? platformContextProperties;

  /// The URL of the media plugin for the JavaScript tracker.
  /// Required in order to track media events on Web.
  /// You may use it from CDN as:
  /// `https://cdn.jsdelivr.net/npm/@snowplow/browser-plugin-media@latest/dist/index.umd.min.js`
  final String? jsMediaPluginURL;

  const TrackerConfiguration(
      {this.appId,
      this.devicePlatform,
      this.base64Encoding,
      this.platformContext,
      this.geoLocationContext,
      this.sessionContext,
      this.webPageContext,
      this.screenContext,
      this.applicationContext,
      this.webActivityTracking,
      this.userAnonymisation,
      this.lifecycleAutotracking,
      this.screenEngagementAutotracking,
      this.platformContextProperties,
      this.jsMediaPluginURL});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'appId': appId,
      'devicePlatform': devicePlatform?.name,
      'base64Encoding': base64Encoding,
      'platformContext': platformContext,
      'geoLocationContext': geoLocationContext,
      'sessionContext': sessionContext,
      'webPageContext': webPageContext,
      'screenContext': screenContext,
      'applicationContext': applicationContext,
      'webActivityTracking': webActivityTracking?.toMap(),
      'userAnonymisation': userAnonymisation,
      'lifecycleAutotracking': lifecycleAutotracking,
      'screenEngagementAutotracking': screenEngagementAutotracking,
      'platformContextProperties': platformContextProperties?.toMap(),
      'jsMediaPluginURL': jsMediaPluginURL
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}

/// Device platform the tracker runs on
enum DevicePlatform {
  /// Mobile/Tablet,
  mob,

  /// Web
  web,

  /// Desktop/Laptop
  pc,

  /// Server-side app
  srv,

  /// General app
  app,

  /// Connected TV
  tv,

  /// Games Console
  cnsl,

  /// Internet of things
  iot
}
