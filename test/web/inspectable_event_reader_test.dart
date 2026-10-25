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

import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/src/web/readers/events/inspectable_event_reader.dart';

void main() {
  const contexts = {
    'schema': 'iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-0',
    'data': [
      {
        'schema': 'iglu:com.acme/entity/jsonschema/1-0-0',
        'data': {'a': 1}
      }
    ]
  };
  const unstructEvent = {
    'schema':
        'iglu:com.snowplowanalytics.snowplow/unstruct_event/jsonschema/1-0-0',
    'data': {
      'schema': 'iglu:com.acme/event/jsonschema/1-0-0',
      'data': {'b': 2}
    }
  };

  String base64Json(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');

  test('reads self-describing event from unencoded payload', () {
    final event = InspectableEventReader.fromPayload({
      'e': 'ue',
      'ue_pr': jsonEncode(unstructEvent),
      'co': jsonEncode(contexts),
    });

    expect(event['schema'], equals('iglu:com.acme/event/jsonschema/1-0-0'));
    expect(event['name'], isNull);
    expect(event['payload'], equals({'b': 2}));
    expect(event['entities'], equals(contexts['data']));
  });

  test('reads self-describing event from base64 encoded payload', () {
    final event = InspectableEventReader.fromPayload({
      'e': 'ue',
      'ue_px': base64Json(unstructEvent),
      'cx': base64Json(contexts),
    });

    expect(event['schema'], equals('iglu:com.acme/event/jsonschema/1-0-0'));
    expect(event['payload'], equals({'b': 2}));
    expect(event['entities'], equals(contexts['data']));
  });

  test('reads primitive event with raw payload', () {
    final event = InspectableEventReader.fromPayload({
      'e': 'se',
      'se_ca': 'category',
    });

    expect(event['schema'], isNull);
    expect(event['name'], equals('se'));
    expect(event['payload'], equals({'e': 'se', 'se_ca': 'category'}));
    expect(event['entities'], isEmpty);
  });
}
