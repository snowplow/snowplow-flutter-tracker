import 'package:flutter/foundation.dart';
import 'package:snowplow_flutter_tracker/helpers.dart';

@immutable
class Configuration {
  final String namespace;
  final NetworkConfiguration networkConfig;
  final TrackerConfiguration? trackerConfig;
  final EmitterConfiguration? emitterConfig;
  final SessionConfiguration? sessionConfig;
  final SubjectConfiguration? subjectConfig;
  final GdprConfiguration? gdprConfig;
  final List<GlobalContextsConfiguration>? gcConfig;

  const Configuration(
      {required this.namespace,
      required this.networkConfig,
      this.trackerConfig,
      this.emitterConfig,
      this.sessionConfig,
      this.subjectConfig,
      this.gdprConfig,
      this.gcConfig});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'namespace': namespace,
      'networkConfig': networkConfig.toMap(),
      'trackerConfig': trackerConfig?.toMap(),
      'emitterConfig': emitterConfig?.toMap(),
      'sessionConfig': sessionConfig?.toMap(),
      'subjectConfig': subjectConfig?.toMap(),
      'gdprConfig': gdprConfig?.toMap(),
      'gcConfig': gcConfig?.map((e) => e.toMap()).toList()
    };
  }
}

@immutable
class NetworkConfiguration {
  final String endpoint;
  final String? method;

  const NetworkConfiguration({required this.endpoint, this.method});

  Map<String, Object?> toMap() {
    return <String, Object?>{'endpoint': endpoint, 'method': method};
  }
}

@immutable
class TrackerConfiguration {
  final String? appId;
  final String? devicePlatform;
  final String? logLevel;
  final bool? base64Encoding;
  final bool? applicationContext;
  final bool? platformContext;
  final bool? geoLocationContext;
  final bool? sessionContext;
  final bool? screenContext;
  final bool? screenViewAutotracking;
  final bool? lifecycleAutotracking;
  final bool? installAutotracking;
  final bool? exceptionAutotracking;
  final bool? diagnosticAutotracking;

  const TrackerConfiguration(
      {this.appId,
      this.devicePlatform,
      this.logLevel,
      this.base64Encoding,
      this.applicationContext,
      this.platformContext,
      this.geoLocationContext,
      this.sessionContext,
      this.screenContext,
      this.screenViewAutotracking,
      this.lifecycleAutotracking,
      this.installAutotracking,
      this.exceptionAutotracking,
      this.diagnosticAutotracking});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'appId': appId,
      'devicePlatform': devicePlatform,
      'logLevel': logLevel,
      'base64Encoding': base64Encoding,
      'applicationContext': applicationContext,
      'platformContext': platformContext,
      'geoLocationContext': geoLocationContext,
      'sessionContext': sessionContext,
      'screenContext': screenContext,
      'screenViewAutotracking': screenViewAutotracking,
      'lifecycleAutotracking': lifecycleAutotracking,
      'installAutotracking': installAutotracking,
      'exceptionAutotracking': exceptionAutotracking,
      'diagnosticAutotracking': diagnosticAutotracking,
    };
  }
}

@immutable
class EmitterConfiguration {
  final String? bufferOption;
  final double? emitRange;
  final double? threadPoolSize;
  final double? byteLimitPost;
  final double? byteLimitGet;

  const EmitterConfiguration(
      {this.bufferOption,
      this.emitRange,
      this.threadPoolSize,
      this.byteLimitPost,
      this.byteLimitGet});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'bufferOption': bufferOption,
      'emitRange': emitRange,
      'threadPoolSize': threadPoolSize,
      'byteLimitPost': byteLimitPost,
      'byteLimitGet': byteLimitGet
    };
  }
}

@immutable
class SessionConfiguration {
  final double? foregroundTimeout;
  final double? backgroundTimeout;

  const SessionConfiguration({this.foregroundTimeout, this.backgroundTimeout});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'foregroundTimeout': foregroundTimeout,
      'backgroundTimeout': backgroundTimeout,
    };
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
    return <String, Object?>{
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
    return <String, Object?>{
      'basisForProcessing': basisForProcessing,
      'documentId': documentId,
      'documentVersion': documentVersion,
      'documentDescription': documentDescription,
    };
  }
}

@immutable
class GlobalContextsConfiguration {
  final String tag;
  final List<Map<String, Object?>> globalContexts;

  const GlobalContextsConfiguration(
      {required this.tag, required this.globalContexts});

  Map<String, Object?> toMap() {
    return <String, Object?>{'tag': tag, 'globalContexts': globalContexts};
  }
}
