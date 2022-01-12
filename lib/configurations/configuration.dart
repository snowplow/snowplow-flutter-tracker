import 'package:flutter/foundation.dart';
import 'package:snowplow_flutter_tracker/configurations/gdpr_configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/network_configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/subject_configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/tracker_configuration.dart';

@immutable
class Configuration {
  final String namespace;
  final NetworkConfiguration networkConfig;
  final TrackerConfiguration? trackerConfig;
  final SubjectConfiguration? subjectConfig;
  final GdprConfiguration? gdprConfig;

  const Configuration(
      {required this.namespace,
      required this.networkConfig,
      this.trackerConfig,
      this.subjectConfig,
      this.gdprConfig});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'namespace': namespace,
      'networkConfig': networkConfig.toMap(),
      'trackerConfig': trackerConfig?.toMap(),
      'subjectConfig': subjectConfig?.toMap(),
      'gdprConfig': gdprConfig?.toMap()
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
