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

/// Subject information about tracked user and device that is added to events.
///
/// {@category Configuration}
@immutable
class SubjectConfiguration {
  /// Business ID of the user.
  final String? userId;

  /// Network user ID (UUIDv4).
  ///
  /// Populates the `network_userid` field.
  /// Typically used to link native tracking to in-app browser events tracked using the JavaScript Tracker.
  /// Normally one would retrieve the network userid from the browser and pass it to the app.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final String? networkUserId;

  /// Domain user ID (UUIDv4).
  ///
  /// Populates the `domain_userid` field.
  /// Typically used to link native tracking to in-app browser events tracked using the JavaScript Tracker.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final String? domainUserId;

  /// Custom user-agent. It overrides the user-agent used by default.
  ///
  /// Populates the `useragent` field.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final String? userAgent;

  /// Custom IP address. It overrides the IP address used by default.
  ///
  /// Populates the `user_ipaddress` field.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final String? ipAddress;

  /// The timezone label.
  ///
  /// Populates the `os_timezone` field.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final String? timezone;

  /// The language set on the device.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final String? language;

  /// The screen resolution on the device.
  ///
  /// Populates the event fields `dvce_screenwidth` and `dvce_screenheight`.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final Size? screenResolution;

  /// The screen viewport.
  ///
  /// Populates the event fields `br_viewwidth` and `br_viewheight`.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final Size? screenViewport;

  /// The color depth.
  ///
  /// Populates the `br_colordepth` field.
  ///
  /// Only configurable on iOS and Android. Ignored on Web where it is automatically assigned.
  final double? colorDepth;

  const SubjectConfiguration(
      {this.userId,
      this.networkUserId,
      this.domainUserId,
      this.userAgent,
      this.ipAddress,
      this.timezone,
      this.language,
      this.screenResolution,
      this.screenViewport,
      this.colorDepth});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'userId': userId,
      'networkUserId': networkUserId,
      'domainUserId': domainUserId,
      'userAgent': userAgent,
      'ipAddress': ipAddress,
      'timezone': timezone,
      'language': language,
      'screenResolution': screenResolution?.toList(),
      'screenViewport': screenViewport?.toList(),
      'colorDepth': colorDepth
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}

/// Resolution or viewport of screen.
@immutable
class Size {
  /// Width in pixels.
  final double width;

  /// Height in pixels.
  final double height;

  const Size({required this.width, required this.height});

  List<double> toList() {
    return [width, height];
  }
}
