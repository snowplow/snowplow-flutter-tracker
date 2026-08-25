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

/// Configuration of the session context (iOS and Android only).
///
/// A new session starts when the app has been in the foreground without any
/// event for longer than [foregroundTimeout], or in the background for longer
/// than [backgroundTimeout]. The native trackers default to 30 minutes each.
@immutable
class SessionConfiguration {
  /// Timeout while the app is in the foreground.
  final Duration? foregroundTimeout;

  /// Timeout while the app is in the background.
  final Duration? backgroundTimeout;

  const SessionConfiguration({this.foregroundTimeout, this.backgroundTimeout});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'foregroundTimeoutSeconds': foregroundTimeout?.inSeconds,
      'backgroundTimeoutSeconds': backgroundTimeout?.inSeconds,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
