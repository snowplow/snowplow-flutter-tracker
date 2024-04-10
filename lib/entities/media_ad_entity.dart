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

///  Properties for the ad context entity attached to media events during ad playback.
/// Entity schema: `iglu:com.snowplowanalytics.snowplow.media/ad/jsonschema/1-0-0`
@immutable
class MediaAdEntity {
  /// Friendly name of the ad
  final String? name;

  /// Unique identifier for the ad
  final String adId;

  /// The ID of the ad creative
  final String? creativeId;

  /// The position of the ad within the ad break, starting with 1
  /// It is automatically assigned by the tracker based on the tracked ad break start and ad start events.
  final int? podPosition;

  /// Length of the video ad in seconds
  final double? duration;

  /// Indicating whether skip controls are made available to the end user
  final bool? skippable;

  const MediaAdEntity(
      {this.name,
      required this.adId,
      this.creativeId,
      this.podPosition,
      this.duration,
      this.skippable});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'name': name,
      'adId': adId,
      'creativeId': creativeId,
      'podPosition': podPosition,
      'duration': duration,
      'skippable': skippable,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
