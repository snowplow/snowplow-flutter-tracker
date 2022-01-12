import 'package:flutter/foundation.dart';

import 'package:snowplow_flutter_tracker/events/event.dart';

@immutable
class SelfDescribing implements Event {
  final String schema;
  final dynamic data;

  const SelfDescribing({required this.schema, required this.data});

  @override
  String endpoint() {
    return 'trackSelfDescribing';
  }

  @override
  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      'schema': schema,
      'data': data,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
