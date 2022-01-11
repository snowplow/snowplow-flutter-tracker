import 'dart:js_util';

import 'package:snowplow_flutter_tracker/web/readers/configurations.dart';
import 'package:snowplow_flutter_tracker/web/readers/messages.dart';
import 'package:snowplow_flutter_tracker/web/sp.dart';
import 'package:snowplow_flutter_tracker/web/readers/events.dart';

class SnowplowFlutterTrackerController {
  static void createTracker(ConfigurationReader configuration) {
    snowplow(
        'newTracker',
        configuration.namespace,
        configuration.networkConfig.endpoint,
        configuration.getTrackerOptions());

    if (configuration.subjectConfig != null &&
        configuration.subjectConfig?.userId != null) {
      _setUserId(configuration.namespace, configuration.subjectConfig?.userId);
    }
    addSessionContextPlugin(configuration.namespace);
  }

  static void trackStructured(EventMessageReader message) {
    trackEvent(message.structured!, message.tracker);
  }

  static void trackSelfDescribing(EventMessageReader message) {
    trackEvent(message.selfDescribing!, message.tracker);
  }

  static void trackScreenView(EventMessageReader message) {
    trackEvent(message.screenView!, message.tracker);
  }

  static void trackTiming(EventMessageReader message) {
    trackEvent(message.timing!, message.tracker);
  }

  static void trackConsentGranted(EventMessageReader message) {
    trackEvent(message.consentGranted!, message.tracker);
  }

  static void trackConsentWithdrawn(EventMessageReader message) {
    trackEvent(message.consentWithdrawn!, message.tracker);
  }

  static void trackEvent(EventReader event, String tracker) {
    snowplow('${event.endpoint()}:$tracker', jsify(event.eventData()));
  }

  static void setUserId(SetUserIdMessageReader message) {
    _setUserId(message.tracker, message.userId);
  }

  static void _setUserId(String tracker, String? userId) {
    snowplow('setUserId:$tracker', userId);
  }
}
