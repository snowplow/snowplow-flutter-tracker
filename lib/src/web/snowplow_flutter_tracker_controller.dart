import 'dart:js_util';

import 'readers/configurations/configuration_reader.dart';
import 'readers/messages/event_message_reader.dart';
import 'readers/messages/set_user_id_message_reader.dart';
import 'sp.dart';

class SnowplowFlutterTrackerController {
  static void createTracker(ConfigurationReader configuration) {
    dynamic options = configuration.getTrackerOptions();
    snowplow('newTracker', configuration.namespace,
        configuration.networkConfig.endpoint, jsify(options));

    if (configuration.subjectConfig != null &&
        configuration.subjectConfig?.userId != null) {
      _setUserId(configuration.namespace, configuration.subjectConfig?.userId);
    }

    if (configuration.gdprConfig != null) {
      snowplow(
          'enableGdprContext',
          jsify({
            'basisForProcessing': configuration.gdprConfig?.basisForProcessing,
            'documentId': configuration.gdprConfig?.documentId,
            'documentVersion': configuration.gdprConfig?.documentVersion,
            'documentDescription': configuration.gdprConfig?.documentDescription
          }));
    }

    addSessionContextPlugin(configuration.namespace);
  }

  static void trackEvent(EventMessageReader message) {
    snowplow('${message.event().endpoint()}:${message.tracker}',
        jsify(message.eventData()));
  }

  static void setUserId(SetUserIdMessageReader message) {
    _setUserId(message.tracker, message.userId);
  }

  static void _setUserId(String tracker, String? userId) {
    snowplow('setUserId:$tracker', userId);
  }

  static String? getSessionUserId() {
    return getSnowplowDuid();
  }

  static String? getSessionId() {
    return getSnowplowSid();
  }

  static int? getSessionIndex() {
    return getSnowplowVid();
  }
}
