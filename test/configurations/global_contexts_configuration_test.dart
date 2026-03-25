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

import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/configurations/global_contexts_configuration.dart';
import 'package:snowplow_tracker/events/self_describing.dart';

void main() {
  group('GlobalContextsConfiguration', () {
    test('toMap includes contexts list with schema and data', () {
      const config = GlobalContextsConfiguration(contexts: [
        SelfDescribing(
          schema: 'iglu:com.example/test/jsonschema/1-0-0',
          data: {'key': 'value'},
        ),
      ]);

      final map = config.toMap();

      expect(map.containsKey('contexts'), isTrue);
      expect(map['contexts'], isA<List>());
      expect((map['contexts'] as List).length, 1);

      final context = (map['contexts'] as List)[0] as Map;
      expect(context['schema'], 'iglu:com.example/test/jsonschema/1-0-0');
      expect(context['data'], {'key': 'value'});
    });

    test('toMap includes empty contexts list', () {
      const config = GlobalContextsConfiguration(contexts: []);

      final map = config.toMap();

      expect(map.containsKey('contexts'), isTrue);
      expect(map['contexts'], []);
    });

    test('toMap with multiple contexts', () {
      const config = GlobalContextsConfiguration(contexts: [
        SelfDescribing(
          schema: 'iglu:com.example/user/jsonschema/1-0-0',
          data: {'userId': '123'},
        ),
        SelfDescribing(
          schema: 'iglu:com.example/session/jsonschema/1-0-0',
          data: {'sessionId': 'abc'},
        ),
      ]);

      final map = config.toMap();

      expect((map['contexts'] as List).length, 2);
      expect(((map['contexts'] as List)[0] as Map)['schema'],
          'iglu:com.example/user/jsonschema/1-0-0');
      expect(((map['contexts'] as List)[1] as Map)['schema'],
          'iglu:com.example/session/jsonschema/1-0-0');
    });
  });
}
