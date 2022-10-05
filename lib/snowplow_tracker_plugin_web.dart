// Copyright (c) 2022 Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'src/web/readers/configurations/configuration_reader.dart';
import 'src/web/readers/messages/event_message_reader.dart';
import 'src/web/readers/messages/set_user_id_message_reader.dart';
import 'src/web/snowplow_tracker_controller.dart';

class SnowplowTrackerPluginWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'snowplow_tracker',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = SnowplowTrackerPluginWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'createTracker':
        return onCreateTracker(call);
      case 'trackStructured':
        return onTrackStructured(call);
      case 'trackSelfDescribing':
        return onTrackSelfDescribing(call);
      case 'trackScreenView':
        return onTrackScreenView(call);
      case 'trackTiming':
        return onTrackTiming(call);
      case 'trackConsentGranted':
        return onTrackConsentGranted(call);
      case 'trackConsentWithdrawn':
        return onTrackConsentWithdrawn(call);
      case 'trackPageView':
        return onTrackPageView(call);
      case 'setUserId':
        return onSetUserId(call);
      case "getSessionUserId":
        return onGetSessionUserId(call);
      case "getSessionId":
        return onGetSessionId(call);
      case "getSessionIndex":
        return onGetSessionIndex(call);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'snowplow_tracker for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  void onCreateTracker(MethodCall call) {
    var configuration = ConfigurationReader(call.arguments);
    SnowplowTrackerController.createTracker(configuration);
  }

  void onTrackStructured(MethodCall call) {
    var message = EventMessageReader.withStructured(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackSelfDescribing(MethodCall call) {
    var message = EventMessageReader.withSelfDescribing(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackScreenView(MethodCall call) {
    var message = EventMessageReader.withScreenView(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackTiming(MethodCall call) {
    var message = EventMessageReader.withTiming(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackConsentGranted(MethodCall call) {
    var message = EventMessageReader.withConsentGranted(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackConsentWithdrawn(MethodCall call) {
    var message = EventMessageReader.withConsentWithdrawn(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackPageView(MethodCall call) {
    var message = EventMessageReader.withPageView(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onSetUserId(MethodCall call) {
    var message = SetUserIdMessageReader(call.arguments);
    SnowplowTrackerController.setUserId(message);
  }

  String? onGetSessionUserId(MethodCall call) {
    return SnowplowTrackerController.getSessionUserId();
  }

  String? onGetSessionId(MethodCall call) {
    return SnowplowTrackerController.getSessionId();
  }

  int? onGetSessionIndex(MethodCall call) {
    return SnowplowTrackerController.getSessionIndex();
  }
}
