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

import 'package:snowplow_flutter_tracker/events/event.dart';

/// Event to track user viewing a screen within the application.
///
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class ScreenView implements Event {
  /// The name of the screen viewed.
  final String name;

  /// The id (UUID v4) of screen that was viewed.
  final String id;

  /// The type of screen that was viewed.
  final String? type;

  /// The name of the previous screen that was viewed.
  final String? previousName;

  /// The type of screen that was viewed.
  final String? previousType;

  /// The id (UUID v4) of the previous screen that was viewed.
  final String? previousId;

  /// The type of transition that led to the screen being viewed.
  final String? transitionType;

  const ScreenView(
      {required this.name,
      required this.id,
      this.type,
      this.previousName,
      this.previousType,
      this.previousId,
      this.transitionType});

  @override
  String endpoint() {
    return 'trackScreenView';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'name': name,
      'id': id,
      'type': type,
      'previousName': previousName,
      'previousType': previousType,
      'previousId': previousId,
      'transitionType': transitionType,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
