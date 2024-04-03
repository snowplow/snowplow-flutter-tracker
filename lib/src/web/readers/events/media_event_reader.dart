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

import 'event_reader.dart';

enum MediaEndpoint {
  startMediaTracking,
  endMediaTracking,
  updateMediaTracking,
  trackMediaAdBreakEnd,
  trackMediaAdBreakStart,
  trackMediaAdClick,
  trackMediaAdComplete,
  trackMediaAdFirstQuartile,
  trackMediaAdMidpoint,
  trackMediaAdPause,
  trackMediaAdResume,
  trackMediaAdSkip,
  trackMediaAdStart,
  trackMediaAdThirdQuartile,
  trackMediaBufferEnd,
  trackMediaBufferStart,
  trackMediaEnd,
  trackMediaError,
  trackMediaFullscreenChange,
  trackMediaPause,
  trackMediaPictureInPictureChange,
  trackMediaPlay,
  trackMediaPlaybackRateChange,
  trackMediaQualityChange,
  trackMediaReady,
  trackMediaSeekEnd,
  trackMediaSeekStart,
  trackMediaVolumeChange,
}

class MediaEventReader implements EventReader {
  final MediaEndpoint mediaEndpoint;
  final Map data;

  MediaEventReader({required this.mediaEndpoint, required this.data});

  @override
  String endpoint() {
    return mediaEndpoint.name;
  }

  @override
  Map eventData() {
    return data;
  }
}
