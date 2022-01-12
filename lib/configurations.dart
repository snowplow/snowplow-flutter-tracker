import 'package:flutter/foundation.dart';
import 'package:snowplow_flutter_tracker/helpers.dart';

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

@immutable
class TrackerConfiguration {
  final String? appId;
  final String? devicePlatform;
  final bool? base64Encoding;
  final bool? platformContext;
  final bool? geoLocationContext;
  final bool? sessionContext;
  final bool? webPageContext;

  const TrackerConfiguration(
      {this.appId,
      this.devicePlatform,
      this.base64Encoding,
      this.platformContext,
      this.geoLocationContext,
      this.sessionContext,
      this.webPageContext});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'appId': appId,
      'devicePlatform': devicePlatform,
      'base64Encoding': base64Encoding,
      'platformContext': platformContext,
      'geoLocationContext': geoLocationContext,
      'sessionContext': sessionContext,
      'webPageContext': webPageContext,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}

@immutable
class SubjectConfiguration {
  final String? userId;
  final String? networkUserId;
  final String? domainUserId;
  final String? userAgent;
  final String? ipAddress;
  final String? timezone;
  final String? language;
  final Size? screenResolution;
  final Size? screenViewport;
  final double? colorDepth;

  const SubjectConfiguration(
      {this.userId,
      this.networkUserId,
      this.domainUserId,
      this.userAgent,
      this.ipAddress,
      this.timezone,
      this.language,
      this.screenResolution,
      this.screenViewport,
      this.colorDepth});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'userId': userId,
      'networkUserId': networkUserId,
      'domainUserId': domainUserId,
      'userAgent': userAgent,
      'ipAddress': ipAddress,
      'timezone': timezone,
      'language': language,
      'screenResolution': screenResolution?.toList(),
      'screenViewport': screenViewport?.toList(),
      'colorDepth': colorDepth
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}

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
