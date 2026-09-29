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

/// Configuration of session tracking.
///
/// {@category Sessions and data model}
/// {@category Initialization and configuration}
@immutable
class SessionConfiguration {
  /// The amount of time that can elapse before the session expires while the
  /// app is in the foreground.
  ///
  /// Only whole seconds are used, and it must be at least 1 second.
  /// Defaults to 30 minutes.
  ///
  /// On Web, it sets the session cookie timeout, which counts down regardless
  /// of whether the page is visible. Trackers on the same page share the
  /// session cookie, so they should use the same value.
  final Duration? foregroundTimeout;

  /// The amount of time that can elapse before the session expires while the
  /// app is in the background.
  ///
  /// Only whole seconds are used, and it must be at least 1 second.
  /// Defaults to 30 minutes. Not available on Web.
  final Duration? backgroundTimeout;

  /// Whether to resume the session persisted from a previous run of the app
  /// if it has not timed out, rather than starting a new session on launch.
  ///
  /// Defaults to false. Not available on Web, where the session is always
  /// kept in a cookie across page loads.
  final bool? continueSessionOnRestart;

  const SessionConfiguration(
      {this.foregroundTimeout,
      this.backgroundTimeout,
      this.continueSessionOnRestart});

  /// Throws an [ArgumentError] if a timeout is shorter than 1 second, which
  /// would otherwise start a new session with every event.
  Map<String, Object?> toMap() {
    _checkTimeout(foregroundTimeout, 'foregroundTimeout');
    _checkTimeout(backgroundTimeout, 'backgroundTimeout');
    final conf = <String, Object?>{
      'foregroundTimeout': foregroundTimeout?.inSeconds,
      'backgroundTimeout': backgroundTimeout?.inSeconds,
      'continueSessionOnRestart': continueSessionOnRestart
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }

  static void _checkTimeout(Duration? timeout, String name) {
    if (timeout != null && timeout.inSeconds < 1) {
      throw ArgumentError.value(timeout, name, 'must be at least 1 second');
    }
  }
}
