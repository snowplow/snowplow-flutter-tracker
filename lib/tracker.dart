import 'dart:async';

import 'package:snowplow_flutter_tracker/events.dart';
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
