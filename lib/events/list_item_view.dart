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

/// Event tracking the view of an item in a list.
/// If screen engagement tracking is enabled, the list item view events will be aggregated into a `screen_summary` entity.
///
/// Schema: `iglu:com.snowplowanalytics.mobile/list_item_view/jsonschema/1-0-0`
///
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class ListItemView implements Event {
  /// Index of the item in the list
  final int index;

  /// Total number of items in the list
  final int? itemsCount;

  const ListItemView({required this.index, this.itemsCount});

  @override
  String endpoint() {
    return 'trackListItemView';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'index': index,
      'itemsCount': itemsCount,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
