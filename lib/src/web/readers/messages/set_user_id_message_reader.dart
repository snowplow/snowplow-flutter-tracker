import 'package:flutter/foundation.dart';

@immutable
class SetUserIdMessageReader {
  final String tracker;
  final String? userId;

  SetUserIdMessageReader(dynamic map)
      : tracker = map['tracker'],
        userId = map['userId'];
}
