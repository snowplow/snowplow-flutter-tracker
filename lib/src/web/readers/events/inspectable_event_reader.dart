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
import 'dart:convert';

/// Reads the raw JavaScript tracker payload passed to the afterTrack plugin
/// callback into the arguments of an `InspectableEvent`.
class InspectableEventReader {
  static Map<String, Object?> fromPayload(Map<Object?, Object?> payload) {
    final eventName = payload['e'] as String?;
    final contexts = _decodeJson(payload['co'], payload['cx']);
    final entities = contexts?['data'] as List<Object?>? ?? const [];

    if (eventName == 'ue') {
      final unstructEvent = _decodeJson(payload['ue_pr'], payload['ue_px']);
      final event = unstructEvent?['data'] as Map<String, Object?>?;
      return {
        'schema': event?['schema'],
        'payload': event?['data'] ?? const {},
        'entities': entities,
      };
    }
    return {
      'name': eventName,
      'payload': Map<String, Object?>.from(
          payload.map((key, value) => MapEntry(key.toString(), value))),
      'entities': entities,
    };
  }

  static Map<String, Object?>? _decodeJson(Object? json, Object? base64Json) {
    if (json is String) {
      return jsonDecode(json) as Map<String, Object?>;
    }
    if (base64Json is String) {
      final decoded =
          utf8.decode(base64Url.decode(base64Url.normalize(base64Json)));
      return jsonDecode(decoded) as Map<String, Object?>;
    }
    return null;
  }
}
