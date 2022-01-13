import 'package:snowplow_flutter_tracker/configurations/tracker_configuration.dart';

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
