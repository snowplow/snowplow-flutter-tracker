//  Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
//
//  This program is licensed to you under the Apache License Version 2.0,
//  and you may not use this file except in compliance with the Apache License
//  Version 2.0. You may obtain a copy of the Apache License Version 2.0 at
//  http://www.apache.org/licenses/LICENSE-2.0.
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the Apache License Version 2.0 is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
//  express or implied. See the Apache License Version 2.0 for the specific
//  language governing permissions and limitations there under.

import 'package:flutter/foundation.dart';

import 'package:snowplow_tracker/events/event.dart';

/// Media player event fired when the user clicked the pause control and stopped the ad creative.
///
/// {@category Media events}
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class MediaErrorEvent implements Event {
  /// Error-identifying code for the playback issue. E.g. E522
  final String? errorCode;

  /// Name for the type of error that occurred in the playback. E.g. forbidden
  final String? errorName;

  /// Longer description for the error that occurred in the playback.
  final String? errorDescription;

  const MediaErrorEvent(
      {this.errorCode, this.errorName, this.errorDescription});

  @override
  String endpoint() {
    return 'trackMediaErrorEvent';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'errorCode': errorCode,
      'errorName': errorName,
      'errorDescription': errorDescription,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
