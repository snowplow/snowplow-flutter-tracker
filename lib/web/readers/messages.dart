import 'package:flutter/foundation.dart';
import 'package:snowplow_flutter_tracker/events.dart';

@immutable
class EventMessageReader {
  final String tracker;
  final Structured? structured;

  const EventMessageReader({required this.tracker, this.structured});

  EventMessageReader.fromMapStructured(dynamic map)
      : tracker = map['tracker'],
        structured = Structured.fromMap(map['eventData']);
}
