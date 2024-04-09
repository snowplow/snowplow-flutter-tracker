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
import '../entities/media_ad_break_entity_reader.dart';
import '../entities/media_ad_entity_reader.dart';
import '../entities/media_player_entity_reader.dart';

@immutable
class UpdateMediaTrackingMessageReader {
  final String tracker;
  final String mediaTrackingId;
  final MediaPlayerEntityReader? player;
  final MediaAdEntityReader? ad;
  final MediaAdBreakEntityReader? adBreak;

  UpdateMediaTrackingMessageReader(dynamic map)
      : tracker = map['tracker'],
        mediaTrackingId = map['mediaTrackingId'],
        player = map['player'] != null
            ? MediaPlayerEntityReader(map['player'])
            : null,
        ad = map['ad'] != null ? MediaAdEntityReader(map['ad']) : null,
        adBreak = map['adBreak'] != null
            ? MediaAdBreakEntityReader(map['adBreak'])
            : null;

  Map toMap() {
    Map config = {
      'id': mediaTrackingId,
    };

    if (player != null) {
      config['player'] = player?.toMap();
    }
    if (ad != null) {
      config['ad'] = ad?.toMap();
    }
    if (adBreak != null) {
      config['adBreak'] = adBreak?.toMap();
    }

    return config;
  }
}
