import 'dart:js_util';

import 'package:snowplow_flutter_tracker/web/readers/configurations.dart';
import 'package:snowplow_flutter_tracker/web/readers/messages.dart';
import 'package:snowplow_flutter_tracker/web/sp.dart';

import 'readers/events.dart';

class SnowplowFlutterTrackerController {
  static void createTracker(ConfigurationReader configuration) {
    snowplow(
        'newTracker',
        configuration.namespace,
        configuration.networkConfig.endpoint,
        configuration.getTrackerOptions());
    configuration.networkConfig.endpoint;
  }

  static void trackStructured(EventMessageReader message) {
    trackEvent(message.structured!);
  }

  static void trackSelfDescribing(EventMessageReader message) {
    trackEvent(message.selfDescribing!);
  }

  static void trackScreenView(EventMessageReader message) {
    trackEvent(message.screenView!);
  }

  static void trackTiming(EventMessageReader message) {
    trackEvent(message.timing!);
  }

  static void trackConsentGranted(EventMessageReader message) {
    trackEvent(message.consentGranted!);
  }

  static void trackConsentWithdrawn(EventMessageReader message) {
    trackEvent(message.consentWithdrawn!);
  }

  static void trackEvent(EventReader event) {
    snowplow(event.endpoint(), jsify(event.eventData()));
  }
}
