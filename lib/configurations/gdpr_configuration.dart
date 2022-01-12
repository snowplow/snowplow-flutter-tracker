import 'package:flutter/foundation.dart';

@immutable
class GdprConfiguration {
  final String basisForProcessing;
  final String documentId;
  final String documentVersion;
  final String documentDescription;

  const GdprConfiguration(
      {required this.basisForProcessing,
      required this.documentId,
      required this.documentVersion,
      required this.documentDescription});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'basisForProcessing': basisForProcessing,
      'documentId': documentId,
      'documentVersion': documentVersion,
      'documentDescription': documentDescription,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
