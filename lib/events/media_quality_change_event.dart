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

/// Media player event tracked when the video playback quality changes.
///
/// {@category Media events}
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class MediaQualityChangeEvent implements Event {
  /// Quality level before the change (e.g., 1080p).
  /// If not set, the previous quality is taken from the last setting in media player.
  final String? previousQuality;

  /// Quality level after the change (e.g., 1080p).
  final String? newQuality;

  /// The current bitrate in bits per second.
  final int? bitrate;

  /// The current number of frames per second.
  final int? framesPerSecond;

  /// Whether the change was automatic or triggered by the user.
  final bool? automatic;

  const MediaQualityChangeEvent(
      {this.previousQuality,
      this.newQuality,
      this.bitrate,
      this.framesPerSecond,
      this.automatic});

  @override
  String endpoint() {
    return 'trackMediaQualityChangeEvent';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'previousQuality': previousQuality,
      'newQuality': newQuality,
      'bitrate': bitrate,
      'framesPerSecond': framesPerSecond,
      'automatic': automatic,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
