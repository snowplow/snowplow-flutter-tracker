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

import 'dart:async';

import 'package:snowplow_flutter_tracker/events/event.dart';
import 'package:snowplow_flutter_tracker/events/self_describing.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';

/// Instance of an initialized Snowplow tracker identified by [namespace].
class Tracker {
  /// Unique tracker namespace.
  final String namespace;

  const Tracker({required this.namespace});

  /// Tracks the given event with optional context entities.
  Future<void> track(Event event, {List<SelfDescribing>? contexts}) async {
    await Snowplow.track(event, tracker: namespace, contexts: contexts);
  }

  /// Sets the business user ID to the string.
  Future<void> setUserId(String? userId) async {
    await Snowplow.setUserId(userId, tracker: namespace);
  }

  /// Returns the identifier (string UUIDv4) for the user of the session.
  ///
  /// All trackers on Web share the same session.
  Future<String?> get sessionUserId async {
    return await Snowplow.getSessionUserId(tracker: namespace);
  }

  /// Returns the identifier (string UUIDv4) for the session.
  ///
  /// All trackers on Web share the same session.
  Future<String?> get sessionId async {
    return await Snowplow.getSessionId(tracker: namespace);
  }

  /// Returns the index (number) of the current session for this user.
  ///
  /// All trackers on Web share the same session.
  Future<int?> get sessionIndex async {
    return await Snowplow.getSessionIndex(tracker: namespace);
  }
}
