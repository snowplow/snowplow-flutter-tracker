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

import 'package:snowplow_tracker/configurations/media_tracking_configuration.dart';
import 'package:snowplow_tracker/src/web/readers/entities/media_player_entity_reader.dart';
import 'package:snowplow_tracker/src/web/readers/events/contexts_reader.dart';
import 'package:snowplow_tracker/src/web/readers/events/self_describing_reader.dart';

class MediaTrackingConfigurationReader extends MediaTrackingConfiguration {
  MediaTrackingConfigurationReader(dynamic map)
      : super(
          id: map['id'],
          boundaries: map['boundaries'] != null
              ? (map['boundaries'] as List).map((e) => e as int).toList()
              : null,
          contexts: map['contexts'] != null
              ? ContextsReader(map['contexts']).selfDescribingJsons.toList()
              : null,
          player: map['player'] != null
              ? MediaPlayerEntityReader(map['player'])
              : null,
          pings: map['pings'],
          pingInterval: map['pingInterval'],
          maxPausedPings: map['maxPausedPings'],
          session: map['session'],
        );

  Map toTrackerOptions() {
    Map config = {
      'id': id,
      'pings': pings,
      'session': session,
    };

    if (boundaries != null) {
      config['boundaries'] = boundaries;
    }
    if (contexts != null) {
      config['context'] =
          contexts?.map((e) => (e as SelfDescribingReader).json()).toList();
    }
    if (player != null) {
      config['player'] = player?.toMap();
    }

    if (pings == false) {
      config['pings'] = false;
    } else {
      var pingsConfig = {};

      if (pingInterval != null) {
        pingsConfig['pingInterval'] = pingInterval;
      }
      if (maxPausedPings != null) {
        pingsConfig['maxPausedPings'] = maxPausedPings;
      }

      if (pingsConfig.isNotEmpty) {
        config['pings'] = pingsConfig;
      } else {
        config['pings'] = true;
      }
    }

    return config;
  }
}
