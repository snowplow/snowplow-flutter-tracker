import 'package:flutter/foundation.dart';

import 'package:snowplow_flutter_tracker/events/event.dart';

@immutable
class Timing implements Event {
  final String category;
  final String variable;
  final int timing;
  final String? label;

  const Timing(
      {required this.category,
      required this.variable,
      required this.timing,
      this.label});

  @override
  String endpoint() {
    return 'trackTiming';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'category': category,
      'variable': variable,
      'timing': timing,
      'label': label,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
