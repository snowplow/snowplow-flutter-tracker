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

/// Configuration of the event emitter.
///
/// {@category Initialization and configuration}
@immutable
class EmitterConfiguration {
  /// Adds a request header ('SP-anonymous') that prevents the event collector
  /// from adding a network_userid cookie, as well as anonymising the user's IP address.
  final bool? serverAnonymisation;

  const EmitterConfiguration({this.serverAnonymisation});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{'serverAnonymisation': serverAnonymisation};
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
