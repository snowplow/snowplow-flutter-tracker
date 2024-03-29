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
  final StructuredReader? structured;
  final SelfDescribingReader? selfDescribing;
  final ScreenViewReader? screenView;
  final ScrollChangedReader? scrollChanged;
  final ListItemViewReader? listItemView;
  final TimingReader? timing;
  final PageViewEventReader? pageView;
  final ConsentGrantedReader? consentGranted;
  final ConsentWithdrawnReader? consentWithdrawn;
  final ContextsReader? contexts;

  const EventMessageReader(
      {required this.tracker,
      this.structured,
      this.selfDescribing,
      this.screenView,
      this.scrollChanged,
      this.listItemView,
      this.timing,
      this.consentGranted,
      this.consentWithdrawn,
      this.pageView,
      this.contexts});

  EventMessageReader.withStructured(dynamic map)
      : tracker = map['tracker'],
        structured = StructuredReader(map['eventData']),
        selfDescribing = null,
        screenView = null,
        scrollChanged = null,
        listItemView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null,
        pageView = null,
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventMessageReader.withSelfDescribing(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = SelfDescribingReader(map['eventData']),
        structured = null,
        screenView = null,
        scrollChanged = null,
        listItemView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null,
        pageView = null,
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventMessageReader.withScreenView(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = ScreenViewReader(map['eventData']),
        scrollChanged = null,
        listItemView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null,
        pageView = null,
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventMessageReader.withScrollChanged(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        scrollChanged = ScrollChangedReader(map['eventData']),
        listItemView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null,
        pageView = null,
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventMessageReader.withListItemView(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        scrollChanged = null,
        listItemView = ListItemViewReader(map['eventData']),
        timing = null,
        consentGranted = null,
        consentWithdrawn = null,
        pageView = null,
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventMessageReader.withTiming(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        scrollChanged = null,
        listItemView = null,
        timing = TimingReader(map['eventData']),
        consentGranted = null,
        consentWithdrawn = null,
        pageView = null,
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventMessageReader.withConsentGranted(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        scrollChanged = null,
        listItemView = null,
        timing = null,
        consentGranted = ConsentGrantedReader(map['eventData']),
        consentWithdrawn = null,
        pageView = null,
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventMessageReader.withConsentWithdrawn(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        scrollChanged = null,
        listItemView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = ConsentWithdrawnReader(map['eventData']),
        pageView = null,
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventMessageReader.withPageView(dynamic map)
      : tracker = map['tracker'],
        selfDescribing = null,
        structured = null,
        screenView = null,
        scrollChanged = null,
        listItemView = null,
        timing = null,
        consentGranted = null,
        consentWithdrawn = null,
        pageView = PageViewEventReader(map['eventData']),
        contexts =
            map['contexts'] != null ? ContextsReader(map['contexts']) : null;

  EventReader event() {
    if (structured != null) return structured!;
    if (selfDescribing != null) return selfDescribing!;
    if (screenView != null) return screenView!;
    if (scrollChanged != null) return scrollChanged!;
    if (listItemView != null) return listItemView!;
    if (timing != null) return timing!;
    if (consentGranted != null) return consentGranted!;
    if (pageView != null) return pageView!;
    return consentWithdrawn!;
  }

  dynamic eventData() {
    EventReader event = this.event();
    dynamic data = event.eventData();
    if (contexts != null) {
      data['context'] =
          contexts?.selfDescribingJsons.map((e) => e.json()).toList();
    }
    return data;
  }
}
