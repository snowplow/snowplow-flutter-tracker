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

/// Type of ads within the break
enum MediaAdBreakType {
  /// Take full control of the video for a period of time
  linear,

  /// Run concurrently to the video
  nonLinear,

  /// Accompany the video but placed outside the player
  companion,
}

/// Properties for the ad break context entity attached to media events during ad break playback.
/// Entity schema: `iglu:com.snowplowanalytics.snowplow.media/ad_break/jsonschema/1-0-0`
@immutable
class MediaAdBreakEntity {
  /// Ad break name (e.g., pre-roll, mid-roll, and post-roll)
  final String? name;

  /// An identifier for the ad break
  final String breakId;

  /// Playback time in seconds at the start of the ad break.
  final double? startTime;

  /// Type of ads within the break
  final MediaAdBreakType? breakType;

  /// The number of ads to be played within the ad break
  final int? podSize;

  const MediaAdBreakEntity(
      {this.name,
      required this.breakId,
      this.startTime,
      this.breakType,
      this.podSize});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'name': name,
      'breakId': breakId,
      'startTime': startTime,
      'breakType': breakType?.name,
      'podSize': podSize,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
