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
import 'package:snowplow_tracker/snowplow_tracker.dart';
import 'package:snowplow_tracker/entities/media_player_entity.dart';

/// Configuration for a `MediaTracking` instance.
@immutable
class MediaTrackingConfiguration {
  /// Unique identifier for the media tracking instance. The same ID is used for media player session if enabled.
  final String id;

  /// Percentage boundaries of the video to track progress events at
  final List<int>? boundaries;

  /// List of context entities to track with media events
  final List<SelfDescribing>? contexts;

  /// Properties of the media player context entity attached to media events.
  final MediaPlayerEntity? player;

  /// Whether to track media ping events. Defaults to true.
  final bool pings;

  /// Interval in seconds in which the media ping events are tracked. Defaults to 30 seconds unless `pings` are disabled.
  final int? pingInterval;

  /// Maximum number of consecutive ping events to send when playback is paused. Defaults to 1 unless`pings` are disabled.
  final int? maxPausedPings;

  /// Whether to track the media player session context entity along with media events.
  /// The session entity contain the `id` identifier as well as statistics about the media playback.
  final bool session;

  const MediaTrackingConfiguration(
      {required this.id,
      this.boundaries,
      this.contexts,
      this.player,
      this.pings = true,
      this.pingInterval,
      this.maxPausedPings,
      this.session = true});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'id': id,
      'boundaries': boundaries,
      'contexts': contexts?.map((e) => e.toMap()).toList(),
      'player': player?.toMap(),
      'pings': pings,
      'pingInterval': pingInterval,
      'maxPausedPings': maxPausedPings,
      'session': session
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
