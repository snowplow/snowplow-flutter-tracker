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
import '../events/media_event_reader.dart';
import '../events/consent_granted_reader.dart';
import '../events/consent_withdrawn_reader.dart';
import '../events/contexts_reader.dart';
import '../events/event_reader.dart';
import '../events/screen_view_reader.dart';
import '../events/self_describing_reader.dart';
import '../events/structured_reader.dart';
import '../events/timing_reader.dart';
import '../events/page_view_event_reader.dart';
import '../events/scroll_changed_reader.dart';
import '../events/list_item_view_reader.dart';

@immutable
class EventMessageReader {
  final String tracker;
  final EventReader event;
  final ContextsReader? contexts;
  final String? mediaTrackingId;
  final MediaPlayerEntityReader? player;
  final MediaAdEntityReader? ad;
  final MediaAdBreakEntityReader? adBreak;

  const EventMessageReader(
      {required this.tracker,
      required this.event,
      this.contexts,
      this.mediaTrackingId,
      this.player,
      this.ad,
      this.adBreak});

  EventMessageReader.withStructured(dynamic map)
      : tracker = map['tracker'],
        event = StructuredReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = null,
        player = null,
        ad = null,
        adBreak = null;

  EventMessageReader.withSelfDescribing(dynamic map)
      : tracker = map['tracker'],
        event = SelfDescribingReader(map['eventData'],
            isMedia: map['mediaTrackingId'] != null),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = map['mediaTrackingId'],
        player = map['player'] != null
            ? MediaPlayerEntityReader(map['player'])
            : null,
        ad = map['ad'] != null ? MediaAdEntityReader(map['ad']) : null,
        adBreak = map['adBreak'] != null
            ? MediaAdBreakEntityReader(map['adBreak'])
            : null;

  EventMessageReader.withScreenView(dynamic map)
      : tracker = map['tracker'],
        event = ScreenViewReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = null,
        player = null,
        ad = null,
        adBreak = null;

  EventMessageReader.withScrollChanged(dynamic map)
      : tracker = map['tracker'],
        event = ScrollChangedReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = null,
        player = null,
        ad = null,
        adBreak = null;

  EventMessageReader.withListItemView(dynamic map)
      : tracker = map['tracker'],
        event = ListItemViewReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = null,
        player = null,
        ad = null,
        adBreak = null;

  EventMessageReader.withTiming(dynamic map)
      : tracker = map['tracker'],
        event = TimingReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = null,
        player = null,
        ad = null,
        adBreak = null;

  EventMessageReader.withConsentGranted(dynamic map)
      : tracker = map['tracker'],
        event = ConsentGrantedReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = null,
        player = null,
        ad = null,
        adBreak = null;

  EventMessageReader.withConsentWithdrawn(dynamic map)
      : tracker = map['tracker'],
        event = ConsentWithdrawnReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = null,
        player = null,
        ad = null,
        adBreak = null;

  EventMessageReader.withPageView(dynamic map)
      : tracker = map['tracker'],
        event = PageViewEventReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = null,
        player = null,
        ad = null,
        adBreak = null;

  EventMessageReader.withMediaEvent(MediaEndpoint mediaEndpoint, dynamic map)
      : tracker = map['tracker'],
        event = MediaEventReader(
            mediaEndpoint: mediaEndpoint, data: map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null,
        mediaTrackingId = map['mediaTrackingId'],
        player = map['player'] != null
            ? MediaPlayerEntityReader(map['player'])
            : null,
        ad = map['ad'] != null ? MediaAdEntityReader(map['ad']) : null,
        adBreak = map['adBreak'] != null
            ? MediaAdBreakEntityReader(map['adBreak'])
            : null;

  dynamic eventData() {
    dynamic data = event.eventData();
    if (contexts != null) {
      data['context'] =
          contexts?.selfDescribingJsons.map((e) => e.json()).toList();
    }
    if (mediaTrackingId != null) {
      data['id'] = mediaTrackingId;
    }
    if (player != null) {
      data['player'] = player?.toMap();
    }
    if (ad != null) {
      data['ad'] = ad?.toMap();
    }
    if (adBreak != null) {
      data['adBreak'] = adBreak?.toMap();
    }
    return data;
  }
}
