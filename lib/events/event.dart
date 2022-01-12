import 'package:flutter/foundation.dart';

@immutable
abstract class Event {
  String endpoint();
  Map<String, Object?> toMap();
}
