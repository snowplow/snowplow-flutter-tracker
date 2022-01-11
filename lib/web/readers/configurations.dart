import 'package:snowplow_flutter_tracker/configurations.dart';

class NetworkConfigurationReader extends NetworkConfiguration {
  NetworkConfigurationReader(dynamic map)
      : super(endpoint: map['endpoint'], method: map['method']);

  void addTrackerOptions(dynamic options) {
    if (method != null) {
      options['eventMethod'] = method;
    }
  }
}

class TrackerConfigurationReader extends TrackerConfiguration {
  TrackerConfigurationReader(dynamic map)
      : super(
            appId: map['appId'],
            devicePlatform: map['devicePlatform'],
            logLevel: map['logLevel'],
            base64Encoding: map['base64Encoding'],
            applicationContext: map['applicationContext'],
            platformContext: map['platformContext'],
            geoLocationContext: map['geoLocationContext'],
            sessionContext: map['sessionContext'],
            screenContext: map['screenContext'],
            screenViewAutotracking: map['screenViewAutotracking'],
            lifecycleAutotracking: map['lifecycleAutotracking'],
            installAutotracking: map['installAutotracking'],
            exceptionAutotracking: map['exceptionAutotracking'],
            diagnosticAutotracking: map['diagnosticAutotracking']);

  void addTrackerOptions(dynamic options) {
    if (appId != null) {
      options['appId'] = appId;
    }
    if (devicePlatform != null) {
      options['platform'] = devicePlatform;
    }
    if (base64Encoding != null) {
      options['encodeBase64'] = base64Encoding;
    }
    var contexts = {};
    if (geoLocationContext != null) {
      contexts['geolocation'] = geoLocationContext;
    }
    if (contexts.isNotEmpty) {
      options['contexts'] = contexts;
    }
  }
}

class EmitterConfigurationReader extends EmitterConfiguration {
  EmitterConfigurationReader(dynamic map)
      : super(
            bufferOption: map['bufferOption'],
            emitRange: map['emitRange'],
            threadPoolSize: map['threadPoolSize'],
            byteLimitGet: map['byteLimitGet'],
            byteLimitPost: map['byteLimitPost']);

  void addTrackerOptions(dynamic options) {
    if (byteLimitPost != null) {
      options['maxPostBytes'] = byteLimitPost;
    }
  }
}

class SubjectConfigurationReader extends SubjectConfiguration {
  SubjectConfigurationReader(dynamic map)
      : super(
            userId: map['userId'],
            networkUserId: map['networkUserId'],
            domainUserId: map['domainUserId'],
            userAgent: map['userAgent'],
            ipAddress: map['ipAddress'],
            timezone: map['timezone'],
            language: map['language'],
            colorDepth: map['colorDepth']);
}

class ConfigurationReader extends Configuration {
  ConfigurationReader(dynamic map)
      : super(
            namespace: map['namespace'],
            networkConfig: NetworkConfigurationReader(map['networkConfig']),
            trackerConfig: map['trackerConfig'] != null
                ? TrackerConfigurationReader(map['trackerConfig'])
                : null,
            emitterConfig: map['emitterConfig'] != null
                ? EmitterConfigurationReader(map['emitterConfig'])
                : null,
            sessionConfig: null,
            subjectConfig: map['subjectConfig'] != null
                ? SubjectConfigurationReader(map['subjectConfig'])
                : null,
            gdprConfig: null,
            gcConfig: null);

  dynamic getTrackerOptions() {
    var options = {};

    (networkConfig as NetworkConfigurationReader).addTrackerOptions(options);
    if (trackerConfig != null) {
      (trackerConfig as TrackerConfigurationReader).addTrackerOptions(options);
    }
    if (emitterConfig != null) {
      (emitterConfig as EmitterConfigurationReader).addTrackerOptions(options);
    }

    return options;
  }
}
