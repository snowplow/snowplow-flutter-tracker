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
