// Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

import 'package:flutter/foundation.dart';
import 'package:snowplow_tracker/events/self_describing.dart';

/// Called with each event after it is tracked.
typedef AfterTrackCallback = void Function(InspectableEvent event);

/// Configuration of a plugin that observes events tracked by a tracker.
///
/// The plugin sees every event the tracker tracks, including events tracked
/// automatically, such as screen views from the [SnowplowObserver], lifecycle,
/// session, installation and media events.
///
/// {@category Initialization and configuration}
@immutable
class PluginConfiguration {
  /// Unique identifier of the plugin within the tracker.
  ///
  /// Adding a plugin with the same identifier replaces the previous one.
  final String identifier;

  /// Callback called after each event is tracked.
  ///
  /// It is called after the event is added to the event queue, not
  /// necessarily after it is sent to the collector. The callback runs
  /// asynchronously, so it may be called after the next event is tracked.
  final AfterTrackCallback? afterTrack;

  const PluginConfiguration({required this.identifier, this.afterTrack});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'identifier': identifier,
      'afterTrack': afterTrack != null ? true : null
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}

/// Event passed to plugin callbacks after it is tracked.
///
/// {@category Initialization and configuration}
@immutable
class InspectableEvent {
  /// Schema of the event, for self-describing events.
  final String? schema;

  /// Name of the event, for events that are not self-describing, such as
  /// `se` for structured events.
  final String? name;

  /// Payload of the event.
  ///
  /// For self-describing events, this is the event data. On Web, for other
  /// events, this is the raw tracker payload.
  final Map<String, Object?> payload;

  /// Context entities attached to the event.
  final List<SelfDescribing> entities;

  const InspectableEvent(
      {this.schema,
      this.name,
      this.payload = const {},
      this.entities = const []});

  InspectableEvent.fromMap(Map<Object?, Object?> map)
      : schema = map['schema'] as String?,
        name = map['name'] as String?,
        payload = Map<String, Object?>.from(
            map['payload'] as Map<Object?, Object?>? ?? const {}),
        entities = (map['entities'] as List<Object?>? ?? const [])
            .map((e) => SelfDescribing.fromMap(
                Map<String, Object?>.from(e as Map<Object?, Object?>)))
            .toList();
}
