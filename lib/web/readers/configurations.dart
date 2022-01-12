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
            base64Encoding: map['base64Encoding'],
            platformContext: map['platformContext'],
            geoLocationContext: map['geoLocationContext'],
            sessionContext: map['sessionContext'],
            webPageContext: map['webPageContext']);

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
    if (webPageContext != null) {
      contexts['webPage'] = webPageContext;
    }
    if (contexts.isNotEmpty) {
      options['contexts'] = contexts;
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

class GdprConfigurationReader extends GdprConfiguration {
  GdprConfigurationReader(dynamic map)
      : super(
            basisForProcessing: map['basisForProcessing'],
            documentId: map['documentId'],
            documentVersion: map['documentVersion'],
            documentDescription: map['documentDescription']);
}

class ConfigurationReader extends Configuration {
  ConfigurationReader(dynamic map)
      : super(
            namespace: map['namespace'],
            networkConfig: NetworkConfigurationReader(map['networkConfig']),
            trackerConfig: map['trackerConfig'] != null
                ? TrackerConfigurationReader(map['trackerConfig'])
                : null,
            subjectConfig: map['subjectConfig'] != null
                ? SubjectConfigurationReader(map['subjectConfig'])
                : null,
            gdprConfig: map['gdprConfig'] != null
                ? GdprConfigurationReader(map['gdprConfig'])
                : null);

  dynamic getTrackerOptions() {
    var options = {};

    (networkConfig as NetworkConfigurationReader).addTrackerOptions(options);
    if (trackerConfig != null) {
      (trackerConfig as TrackerConfigurationReader).addTrackerOptions(options);
    }

    return options;
  }
}
