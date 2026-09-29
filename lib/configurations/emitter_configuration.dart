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

/// Configuration of the event emitter.
///
/// {@category Initialization and configuration}
@immutable
class EmitterConfiguration {
  /// Adds a request header ('SP-anonymous') that prevents the event collector
  /// from adding a network_userid cookie, as well as anonymising the user's IP address.
  /// Setting serverAnonymisation also enables (and overrides) TrackerConfiguration.userAnonymisation.
  final bool? serverAnonymisation;

  /// Limit for the maximum number of unsent events to keep in the event store.
  ///
  /// When the tracker next tries to send events and the limit is exceeded, the
  /// oldest events are removed. Must be greater than 0.
  /// Defaults to 1000. Not available on Web.
  final int? maxEventStoreSize;

  /// Limit for how long unsent events are kept in the event store.
  ///
  /// When the tracker next tries to send events, events older than this are
  /// removed. Only whole seconds are used, and it must be at least 1 second.
  /// Defaults to 30 days. Not available on Web.
  final Duration? maxEventStoreAge;

  const EmitterConfiguration(
      {this.serverAnonymisation,
      this.maxEventStoreSize,
      this.maxEventStoreAge});

  /// Throws an [ArgumentError] if an event store limit is out of range, as
  /// the native trackers would otherwise delete all unsent events.
  Map<String, Object?> toMap() {
    if (maxEventStoreSize != null && maxEventStoreSize! <= 0) {
      throw ArgumentError.value(
          maxEventStoreSize, 'maxEventStoreSize', 'must be greater than 0');
    }
    if (maxEventStoreAge != null && maxEventStoreAge!.inSeconds < 1) {
      throw ArgumentError.value(
          maxEventStoreAge, 'maxEventStoreAge', 'must be at least 1 second');
    }
    final conf = <String, Object?>{
      'serverAnonymisation': serverAnonymisation,
      'maxEventStoreSize': maxEventStoreSize,
      'maxEventStoreAge': maxEventStoreAge?.inSeconds
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
