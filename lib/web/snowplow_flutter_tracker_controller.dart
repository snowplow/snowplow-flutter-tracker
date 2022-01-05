import 'package:snowplow_flutter_tracker/configurations.dart';
import 'package:snowplow_flutter_tracker/web/readers/messages.dart';
import 'package:snowplow_flutter_tracker/web/sp.dart';

class SnowplowFlutterTrackerController {
  static void createTracker(Configuration configuration) {
    snowplow(
        'newTracker',
        configuration.namespace,
        configuration.networkConfig.endpoint,
        {'appId': configuration.trackerConfig?.appId});
    configuration.networkConfig.endpoint;
  }

  static void trackStructured(EventMessageReader message) {
    var event = message.structured;
    snowplow('trackStructEvent', {
      'category': event?.category,
      'action': event?.action,
      'label': event?.label,
      'property': event?.property,
      'value': event?.value
    });
  }
}
