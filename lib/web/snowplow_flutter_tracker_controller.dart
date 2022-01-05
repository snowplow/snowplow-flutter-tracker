import 'dart:js_util';

import 'package:snowplow_flutter_tracker/configurations.dart';
import 'package:snowplow_flutter_tracker/web/readers/configurations.dart';
import 'package:snowplow_flutter_tracker/web/readers/messages.dart';
import 'package:snowplow_flutter_tracker/web/sp.dart';

class SnowplowFlutterTrackerController {
  static void createTracker(Configuration configuration) {
    snowplow(
        'newTracker',
        configuration.namespace,
        configuration.networkConfig.endpoint,
        ConfigurationReader.toNewTrackerOptions(configuration));
    configuration.networkConfig.endpoint;
  }

  static void trackStructured(EventMessageReader message) {
    var event = message.structured;
    snowplow(
        'trackStructEvent',
        jsify({
          'category': event?.category,
          'action': event?.action,
          'label': event?.label,
          'property': event?.property,
          'value': event?.value
        }));
  }

  static void trackSelfDescribing(EventMessageReader message) {
    var event = message.selfDescribing;
    snowplow(
        'trackSelfDescribingEvent',
        jsify({
          'event': {'schema': event?.schema, 'data': event?.data}
        }));
  }

  static void trackScreenView(EventMessageReader message) {
    var event = message.screenView;
    var data = {
      'name': event?.name,
      'id': event?.id,
      'type': event?.type,
      'previousName': event?.previousName,
      'previousId': event?.previousId,
      'previousType': event?.previousType,
      'transitionType': event?.transitionType
    };
    data.removeWhere((key, value) => value == null);
    snowplow(
        'trackSelfDescribingEvent',
        jsify({
          'event': {
            'schema':
                'iglu:com.snowplowanalytics.mobile/screen_view/jsonschema/1-0-0',
            'data': data
          }
        }));
  }

  static void trackTiming(EventMessageReader message) {
    var event = message.timing;
    snowplow(
        'trackTiming',
        jsify({
          'category': event?.category,
          'variable': event?.variable,
          'timing': event?.timing,
          'label': event?.label,
        }));
  }

  static void trackConsentGranted(EventMessageReader message) {
    var event = message.consentGranted;
    snowplow(
        'trackConsentGranted',
        jsify({
          'id': event?.documentId,
          'version': event?.version,
          'name': event?.name,
          'description': event?.documentDescription,
          'expiry': event?.expiry
        }));
  }

  static void trackConsentWithdrawn(EventMessageReader message) {
    var event = message.consentWithdrawn;
    snowplow(
        'trackConsentWithdrawn',
        jsify({
          'all': event?.all,
          'id': event?.documentId,
          'version': event?.version,
          'name': event?.name,
          'description': event?.documentDescription
        }));
  }
}
