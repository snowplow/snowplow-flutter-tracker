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

/// Event used to track user timing events such as how long resources take to load.
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class Timing implements Event {
  /// Defines the timing category.
  final String category;

  /// Defines the timing variable measured.
  final String variable;

  /// Represents the time.
  final int timing;

  /// An optional string to further identify the timing event.
  final String? label;

  const Timing(
      {required this.category,
      required this.variable,
      required this.timing,
      this.label});

  @override
  String endpoint() {
    return 'trackTiming';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'category': category,
      'variable': variable,
      'timing': timing,
      'label': label,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
