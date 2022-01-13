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

class Tracker {
  final String namespace;

  const Tracker({required this.namespace});

  Future<void> track(Event event, {List<SelfDescribing>? contexts}) async {
    await Snowplow.track(event, tracker: namespace, contexts: contexts);
  }

  Future<void> setUserId(String? userId) async {
    await Snowplow.setUserId(userId, tracker: namespace);
  }

  Future<String?> get sessionUserId async {
    return await Snowplow.getSessionUserId(tracker: namespace);
  }

  Future<String?> get sessionId async {
    return await Snowplow.getSessionId(tracker: namespace);
  }

  Future<int?> get sessionIndex async {
    return await Snowplow.getSessionIndex(tracker: namespace);
  }
}
