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

/// Configuration of the tracker and the core tracker properties.
///
/// Indicates what should be tracked in terms of automatic tracking and contexts/entities to attach to the events.
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

  /// Indicates whether context about current web page should be attached to tracked events.
  ///
  /// Only available on Web, defaults to true.
  final bool? webPageContext;

  const TrackerConfiguration(
      {this.appId,
      this.devicePlatform,
      this.base64Encoding,
      this.platformContext,
      this.geoLocationContext,
      this.sessionContext,
      this.webPageContext});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'appId': appId,
      'devicePlatform': devicePlatform?.name,
      'base64Encoding': base64Encoding,
      'platformContext': platformContext,
      'geoLocationContext': geoLocationContext,
      'sessionContext': sessionContext,
      'webPageContext': webPageContext,
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
