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
