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

@immutable
class TrackerConfiguration {
  final String? appId;
  final String? devicePlatform;
  final bool? base64Encoding;
  final bool? platformContext;
  final bool? geoLocationContext;
  final bool? sessionContext;
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
      'devicePlatform': devicePlatform,
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
