//  Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
//
//  This program is licensed to you under the Apache License Version 2.0,
//  and you may not use this file except in compliance with the Apache License
//  Version 2.0. You may obtain a copy of the Apache License Version 2.0 at
//  http://www.apache.org/licenses/LICENSE-2.0.
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the Apache License Version 2.0 is distributed on
//  an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
//  express or implied. See the Apache License Version 2.0 for the specific
//  language governing permissions and limitations there under.

import 'package:flutter/foundation.dart';

import 'package:snowplow_tracker/events/event.dart';

/// Media player event sent when the volume has changed.
///
/// {@category Media events}
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class MediaVolumeChangeEvent implements Event {
  /// Volume percentage before the change.
  /// If not set, the previous volume is taken from the last setting in media player.
  final int? previousVolume;

  /// Volume percentage after the change.
  final int newVolume;

  const MediaVolumeChangeEvent({required this.newVolume, this.previousVolume});

  @override
  String endpoint() {
    return 'trackMediaVolumeChangeEvent';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'newVolume': newVolume,
      'previousVolume': previousVolume,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
