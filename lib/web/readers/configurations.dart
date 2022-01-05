import 'package:snowplow_flutter_tracker/configurations.dart';

class ConfigurationReader {
  static dynamic toNewTrackerOptions(Configuration configuration) {
    var options = {};

    // network config
    if (configuration.networkConfig.method != null) {
      options['eventMethod'] = configuration.networkConfig.method;
    }

    // tracker config
    if (configuration.trackerConfig?.appId != null) {
      options['appId'] = configuration.trackerConfig?.appId;
    }
    if (configuration.trackerConfig?.devicePlatform != null) {
      options['platform'] = configuration.trackerConfig?.devicePlatform;
    }
    if (configuration.trackerConfig?.base64Encoding != null) {
      options['encodeBase64'] = configuration.trackerConfig?.base64Encoding;
    }
    var contexts = {};
    if (configuration.trackerConfig?.geoLocationContext != null) {
      contexts['geolocation'] = configuration.trackerConfig?.geoLocationContext;
    }
    if (contexts.isNotEmpty) {
      options['contexts'] = contexts;
    }

    if (configuration.emitterConfig?.byteLimitPost != null) {
      options['maxPostBytes'] = configuration.emitterConfig?.byteLimitPost;
    }

    return options;
  }
}
