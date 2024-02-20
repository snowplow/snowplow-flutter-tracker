// Copyright (c) 2022 Snowplow Analytics Ltd. All rights reserved.
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

/// Event tracked when a scroll view's scroll position changes.
/// If screen engagement tracking is enabled, the scroll changed events will be aggregated into a `screen_summary` entity.
///
/// Schema: `iglu:com.snowplowanalytics.mobile/scroll_changed/jsonschema/1-0-0`
///
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class ScrollChanged implements Event {
  /// Vertical scroll offset in pixels
  final int? yOffset;

  /// Horizontal scroll offset in pixels.
  final int? xOffset;

  /// The height of the scroll view in pixels
  final int? viewHeight;

  /// The width of the scroll view in pixels
  final int? viewWidth;

  /// The height of the content in the scroll view in pixels
  final int? contentHeight;

  /// The width of the content in the scroll view in pixels
  final int? contentWidth;

  const ScrollChanged(
      {this.yOffset,
      this.xOffset,
      this.viewHeight,
      this.viewWidth,
      this.contentHeight,
      this.contentWidth});

  @override
  String endpoint() {
    return 'trackScrollChanged';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'yOffset': yOffset,
      'xOffset': xOffset,
      'viewHeight': viewHeight,
      'viewWidth': viewWidth,
      'contentHeight': contentHeight,
      'contentWidth': contentWidth,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
