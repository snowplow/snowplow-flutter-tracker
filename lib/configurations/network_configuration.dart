import 'package:flutter/foundation.dart';

@immutable
class NetworkConfiguration {
  final String endpoint;
  final String? method;

  const NetworkConfiguration({required this.endpoint, this.method});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{'endpoint': endpoint, 'method': method};
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
