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

/// Type of media content.
enum MediaType {
  /// Audio content
  audio,

  /// Video content
  video,
}

/// Properties for the media player context entity attached to media events.
/// Entity schema: `iglu:com.snowplowanalytics.snowplow/media_player/jsonschema/2-0-0`
@immutable
class MediaPlayerEntity {
  /// The current playback time position within the media in seconds
  final double? currentTime;

  /// A double-precision floating-point value indicating the duration of the media in seconds
  final double? duration;

  /// If playback of the media has ended
  final bool? ended;

  /// Whether the video element is fullscreen
  final bool? fullscreen;

  /// Whether the media is a live stream
  final bool? livestream;

  /// Human readable name given to tracked media content.
  final String? label;

  /// If the video should restart after ending
  final bool? loop;

  /// Type of media content.
  final MediaType? mediaType;

  /// If the media element is muted
  final bool? muted;

  /// If the media element is paused
  final bool? paused;

  /// Whether the video element is showing picture-in-picture
  final bool? pictureInPicture;

  /// Type of the media player (e.g., com.youtube-youtube, com.vimeo-vimeo, org.whatwg-media_element)
  final String? playerType;

  /// Playback rate (1 is normal)
  final double? playbackRate;

  /// Quality level of the playback (e.g., 1080p).
  final String? quality;

  /// Volume percent (0 to 100)
  final int? volume;

  const MediaPlayerEntity({
    this.currentTime,
    this.duration,
    this.ended,
    this.fullscreen,
    this.livestream,
    this.label,
    this.loop,
    this.mediaType,
    this.muted,
    this.paused,
    this.pictureInPicture,
    this.playerType,
    this.playbackRate,
    this.quality,
    this.volume,
  });

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'currentTime': currentTime,
      'duration': duration,
      'ended': ended,
      'fullscreen': fullscreen,
      'livestream': livestream,
      'label': label,
      'loop': loop,
      'mediaType': mediaType?.name,
      'muted': muted,
      'paused': paused,
      'pictureInPicture': pictureInPicture,
      'playerType': playerType,
      'playbackRate': playbackRate,
      'quality': quality,
      'volume': volume,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
