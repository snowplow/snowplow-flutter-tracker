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

/// Event to capture custom consumer interactions without the need to define a custom schema.
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class Structured implements Event {
  /// Name you for the group of objects you want to track e.g. "media", "ecomm".
  final String category;

  /// Defines the type of user interaction for the web object.
  ///
  /// E.g., "play-video", "add-to-basket".
  final String action;

  /// Identifies the specific object being actioned.
  ///
  /// E.g., ID of the video being played, or the SKU or the product added-to-basket.
  final String? label;

  /// Describes the object or the action performed on it.
  ///
  /// This might be the quantity of an item added to basket
  final String? property;

  /// Quantifies or further describes the user action.
  ///
  /// This might be the price of an item added-to-basket, or the starting time of the video where play was just pressed.
  final double? value;

  const Structured(
      {required this.category,
      required this.action,
      this.label,
      this.property,
      this.value});

  @override
  String endpoint() {
    return 'trackStructured';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'category': category,
      'action': action,
      'label': label,
      'property': property,
      'value': value,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
