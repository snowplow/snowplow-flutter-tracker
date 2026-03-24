import 'package:flutter/foundation.dart';
import 'package:snowplow_tracker/events/self_describing.dart';

/// Configuration for global contexts that are automatically attached to every tracked event.
///
/// Global contexts are static entity schemas that will be appended to all events without
/// needing to pass them on each `tracker.track()` call.
@immutable
class GlobalContextsConfiguration {
  /// List of static context entities to attach to all tracked events.
  final List<SelfDescribing> contexts;

  const GlobalContextsConfiguration({
    required this.contexts,
  });

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'contexts': contexts.map((c) => c.toMap()).toList(),
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
