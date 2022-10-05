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
import 'package:snowplow_tracker/configurations/configuration.dart';
import 'package:snowplow_tracker/configurations/gdpr_configuration.dart';
import 'package:snowplow_tracker/configurations/network_configuration.dart';
import 'package:snowplow_tracker/configurations/subject_configuration.dart';
import 'package:snowplow_tracker/configurations/tracker_configuration.dart';
import 'package:snowplow_tracker/events/event.dart';
import 'package:snowplow_tracker/events/self_describing.dart';
import 'package:snowplow_tracker/tracker.dart';

/// Main interface for the package mainly used to initialize trackers and track events.
///
/// {@category Getting started}
/// {@category Initialization and configuration}
class Snowplow {
  static const MethodChannel _channel = MethodChannel('snowplow_tracker');

  /// Creates a new tracker instance with the given unique [namespace].
  ///
  /// [endpoint] refers to the Snowplow collector endpoint.
  /// [method] is the HTTP method used to send events to collector and it defaults to POST.
  /// [customPostPath] is an optional string for custom POST collector paths. Do not include a starting "/".
  static Future<SnowplowTracker> createTracker(
      {required String namespace,
      required String endpoint,
      Method? method,
      String? customPostPath,
      TrackerConfiguration? trackerConfig,
      SubjectConfiguration? subjectConfig,
      GdprConfiguration? gdprConfig}) async {
    final configuration = Configuration(
        namespace: namespace,
        networkConfig: NetworkConfiguration(
            endpoint: endpoint, method: method, customPostPath: customPostPath),
        trackerConfig: trackerConfig,
        subjectConfig: subjectConfig,
        gdprConfig: gdprConfig);
    await _channel.invokeMethod('createTracker', configuration.toMap());
    return SnowplowTracker(configuration: configuration);
  }

  /// Tracks the given event using the specified [tracker] namespace and with optional context entities.
  static Future<void> track(Event event,
      {required String tracker, List<SelfDescribing>? contexts}) async {
    var message = {
      'tracker': tracker,
      'eventData': event.toMap(),
      'contexts': contexts?.map((c) => c.toMap()).toList()
    };
    message.removeWhere((key, value) => value == null);
    await _channel.invokeMethod(event.endpoint(), message);
  }

  /// Sets the business user ID to the string for the [tracker] namespace.
  static Future<void> setUserId(String? userId,
      {required String tracker}) async {
    await _channel
        .invokeMethod('setUserId', {'tracker': tracker, 'userId': userId});
  }

  /// Returns the identifier (string UUIDv4) for the user of the session.
  ///
  /// The [tracker] namespace is required but ignored on Web where all trackers share the same session.
  static Future<String?> getSessionUserId({required String tracker}) async {
    return await _channel
        .invokeMethod('getSessionUserId', {'tracker': tracker});
  }

  /// Returns the identifier (string UUIDv4) for the session.
  ///
  /// The [tracker] namespace is required but ignored on Web where all trackers share the same session.
  static Future<String?> getSessionId({required String tracker}) async {
    return await _channel.invokeMethod('getSessionId', {'tracker': tracker});
  }

  /// Returns the index (number) of the current session for this user.
  ///
  /// The [tracker] namespace is required but ignored on Web where all trackers share the same session.
  static Future<int?> getSessionIndex({required String tracker}) async {
    return await _channel.invokeMethod('getSessionIndex', {'tracker': tracker});
  }
}
