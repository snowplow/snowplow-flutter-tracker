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

/// Media player event fired immediately after the browser switches into or out of full-screen mode.
///
/// {@category Media events}
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class MediaFullscreenChangeEvent implements Event {
  /// Whether the video element is fullscreen after the change.
  final bool fullscreen;

  const MediaFullscreenChangeEvent({required this.fullscreen});

  @override
  String endpoint() {
    return 'trackMediaFullscreenChangeEvent';
  }

  @override
  Map<String, Object?> toMap() {
    return <String, Object?>{
      'fullscreen': fullscreen,
    };
  }
}
