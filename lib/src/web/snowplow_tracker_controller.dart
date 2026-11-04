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

import 'dart:js_interop';
import 'package:flutter/foundation.dart' show debugPrint;
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' show document;

import 'readers/messages/end_media_tracking_message_reader.dart';
import 'readers/messages/start_media_tracking_message_reader.dart';
import 'readers/messages/update_media_tracking_message_reader.dart';

import 'readers/configurations/configuration_reader.dart';
import 'readers/events/inspectable_event_reader.dart';
import 'readers/messages/event_message_reader.dart';
import 'readers/messages/set_user_id_message_reader.dart';
import 'sp.dart';

class SnowplowTrackerController {
  /// Plugins already added to the JavaScript tracker by tracker namespace.
  ///
  /// The JavaScript tracker can't remove plugins, so they are added once and
  /// read the current afterTrack listener and entities when events are tracked.
  static final Map<String, Set<String>> _addedPlugins = {};

  static void createTracker(ConfigurationReader configuration) {
    // The JavaScript tracker keeps an existing tracker and its plugins, so
    // only the plugins in the new configuration keep their listeners and
    // entities.
    final namespace = configuration.namespace;
    _afterTrackListeners.remove(namespace);
    _pluginsWithEntities.remove(namespace);
    _updateEntities(() => _pluginEntities.remove(namespace));

    final options = configuration.getTrackerOptions();
    snowplow('newTracker', configuration.namespace.toJS,
        configuration.networkConfig.endpoint.toJS, options.jsify());

    if (configuration.subjectConfig != null &&
        configuration.subjectConfig?.userId != null) {
      _setUserId(configuration.namespace, configuration.subjectConfig?.userId);
    }

    // Note: GDPR context requires the ConsentPlugin in v4
    // See: https://docs.snowplow.io/docs/sources/web-trackers/tracking-events/consent-gdpr/

    if (configuration
            .trackerConfig?.webActivityTracking?.enableActivityTracking ??
        false) {
      final webActivityTracking =
          configuration.trackerConfig!.webActivityTracking!;
      snowplow(
          'enableActivityTracking',
          {
            'minimumVisitLength': webActivityTracking.minimumVisitLength,
            'heartbeatDelay': webActivityTracking.heartbeatDelay
          }.jsify());
    }

    if (configuration.trackerConfig?.jsMediaPluginURL != null) {
      snowplow('addPlugin', configuration.trackerConfig?.jsMediaPluginURL?.toJS,
          ['snowplowMedia', 'SnowplowMediaPlugin'].jsify());
    }
  }

  /// afterTrack listeners of plugins by tracker namespace and plugin identifier.
  static final Map<String, Map<String, void Function(Map<String, Object?>)>>
      _afterTrackListeners = {};

  /// Entities of plugins by tracker namespace and plugin identifier, as read
  /// by the JavaScript plugins when events are tracked.
  ///
  /// Changes go through [_updateEntities], so they apply in the same order as
  /// the tracking commands.
  static final Map<String, Map<String, List<Object?>>> _pluginEntities = {};

  /// Identifiers of the plugins with entities by tracker namespace, including
  /// changes that [_pluginEntities] hasn't applied yet.
  static final Map<String, Set<String>> _pluginsWithEntities = {};

  /// JavaScript tracker command that applies a change in [_pendingUpdates].
  ///
  /// It's registered by the first plugin added, as plugins can add commands.
  static const _applyUpdateCommand = 'snowplowFlutterApplyPluginUpdate';
  static bool _applyUpdateCommandRegistered = false;
  static final Map<int, void Function()> _pendingUpdates = {};
  static int _nextUpdateId = 0;

  /// Applies [update] to [_pluginEntities] in the order of the tracking
  /// commands.
  ///
  /// The JavaScript tracker queues commands while its script or a plugin
  /// script loads. Events tracked before the update but still queued then
  /// keep the previous entities.
  static void _updateEntities(void Function() update) {
    if (!_applyUpdateCommandRegistered) {
      // no JavaScript plugin reads the entities yet
      update();
      return;
    }
    final id = _nextUpdateId++;
    _pendingUpdates[id] = update;
    snowplow(_applyUpdateCommand, id.toJS);
  }

  /// Adds a JavaScript plugin that sends the arguments of its afterTrack
  /// callbacks to [afterTrackListener] and adds the [entities] to events.
  static void addPlugin(String tracker, String identifier,
      {void Function(Map<String, Object?>)? afterTrackListener,
      List<Object?>? entities}) {
    final listeners = _afterTrackListeners.putIfAbsent(tracker, () => {});
    if (afterTrackListener == null) {
      listeners.remove(identifier);
    } else {
      listeners[identifier] = afterTrackListener;
    }
    final withEntities = _pluginsWithEntities.putIfAbsent(tracker, () => {});
    if (entities == null) {
      withEntities.remove(identifier);
      _updateEntities(() => _pluginEntities[tracker]?.remove(identifier));
    } else {
      withEntities.add(identifier);
      _updateEntities(() => _pluginEntities.putIfAbsent(
          tracker, () => {})[identifier] = entities);
    }

    if (!_addedPlugins.putIfAbsent(tracker, () => {}).add(identifier)) {
      return;
    }

    final plugin = JSObject();
    plugin['afterTrack'] = ((JSAny? payload) {
      final listener = _afterTrackListeners[tracker]?[identifier];
      if (listener == null) {
        return;
      }
      final event = InspectableEventReader.fromPayload(
          payload.dartify() as Map<Object?, Object?>? ?? const {});
      listener({'tracker': tracker, 'plugin': identifier, 'event': event});
    }).toJS;
    plugin['contexts'] = (() =>
        (_pluginEntities[tracker]?[identifier] ?? const []).jsify()).toJS;
    final pluginFactory = JSObject();
    pluginFactory['create'] = (() => plugin).toJS;
    // other properties of the factory become commands of the JavaScript tracker
    pluginFactory[_applyUpdateCommand] = ((JSNumber id, JSAny? trackers) {
      _pendingUpdates.remove(id.toDartInt)?.call();
    }).toJS;
    snowplow('addPlugin:$tracker', pluginFactory, 'create'.toJS);
    _applyUpdateCommandRegistered = true;
  }

  /// Replaces the entities of a plugin that was added with entities.
  static void setPluginEntities(
      String tracker, String identifier, List<Object?> entities) {
    if (_pluginsWithEntities[tracker]?.contains(identifier) != true) {
      debugPrint("SnowplowTracker: setPluginEntities: no plugin '$identifier' "
          "with entities in tracker '$tracker', ignoring");
      return;
    }
    _updateEntities(() => _pluginEntities[tracker]?[identifier] = entities);
  }

  /// Stops calling the plugin's afterTrack listener and adding its entities,
  /// as the JavaScript tracker can't remove plugins.
  static void removePlugin(String tracker, String identifier) {
    _afterTrackListeners[tracker]?.remove(identifier);
    _pluginsWithEntities[tracker]?.remove(identifier);
    _updateEntities(() => _pluginEntities[tracker]?.remove(identifier));
  }

  static void trackEvent(EventMessageReader message) {
    snowplow('${message.event.endpoint()}:${message.tracker}',
        message.eventData().jsify());
  }

  static void setUserId(SetUserIdMessageReader message) {
    _setUserId(message.tracker, message.userId);
  }

  static void _setUserId(String tracker, String? userId) {
    snowplow('setUserId:$tracker', userId?.toJS);
  }

  static String? getSessionUserId() {
    return _getSnowplowCookieParts()?[0];
  }

  static String? getSessionId() {
    return _getSnowplowCookieParts()?[5];
  }

  static int? getSessionIndex() {
    final cookiePart = _getSnowplowCookieParts()?[2];
    if (cookiePart != null) {
      return int.tryParse(cookiePart);
    }
    return null;
  }

  static void startNewSession(String tracker) {
    snowplow('newSession:$tracker');
  }

  static void startMediaTracking(StartMediaTrackingMessageReader message) {
    snowplow('startMediaTracking:${message.tracker}',
        message.configuration.toTrackerOptions().jsify());
  }

  static void endMediaTracking(EndMediaTrackingMessageReader message) {
    snowplow('endMediaTracking:${message.tracker}',
        {'id': message.mediaTrackingId}.jsify());
  }

  static void updateMediaTracking(UpdateMediaTrackingMessageReader message) {
    snowplow('updateMediaTracking:${message.tracker}', message.toMap().jsify());
  }

  static List<String>? _getSnowplowCookieParts() {
    final regex = RegExp(r'_sp_id\.[a-f0-9]+=([^;]+);?');
    final cookieValue = regex.firstMatch(document.cookie)?.group(1);
    return cookieValue?.split('.');
  }

  static void addGlobalContexts(String tracker, String tag, dynamic context) {
    if (context != null) {
      snowplow('addGlobalContexts', {tag: context}.jsify());
    }
  }

  static void removeGlobalContexts(String tracker, String tag) {
    snowplow('removeGlobalContexts', [tag].jsify());
  }
}
