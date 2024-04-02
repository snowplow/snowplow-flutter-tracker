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
import 'package:snowplow_tracker/events/event.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';

/// Media tracking instance with methods to track media events.
@immutable
class MediaTracking {
  /// Unique identifier for the media tracking instance. The same ID is used for media player session if enabled.
  final String id;
  final String tracker;

  const MediaTracking({required this.id, required this.tracker});

  /// Updates stored attributes of the media player such as the current playback.
  /// Use this function to continually update the player attributes so that they can be sent in the background ping events.
  Future<void> update(
      {MediaPlayerEntity? player,
      MediaAdEntity? ad,
      MediaAdBreakEntity? adBreak}) async {
    await Snowplow.updateMediaTracking(
        tracker: tracker, id: id, player: player, ad: ad, adBreak: adBreak);
  }

  /// Tracks a media player event along with the media entities (e.g., player, session, ad).
  Future<void> track(Event event,
      {List<SelfDescribing>? contexts,
      MediaPlayerEntity? player,
      MediaAdEntity? ad,
      MediaAdBreakEntity? adBreak}) async {
    await Snowplow.trackMediaEvent(
        tracker: tracker,
        id: id,
        event: event,
        contexts: contexts,
        player: player,
        ad: ad,
        adBreak: adBreak);
  }
}
