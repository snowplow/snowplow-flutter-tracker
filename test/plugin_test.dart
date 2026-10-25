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
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';

void main() {
  const MethodChannel channel = MethodChannel('snowplow_tracker');
  List<MethodCall> calls = [];

  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> sendAfterTrack(String tracker, String plugin,
      [Map<String, Object?> event = const {}]) async {
    final message = const StandardMethodCodec().encodeMethodCall(MethodCall(
        'afterTrack', {'tracker': tracker, 'plugin': plugin, 'event': event}));
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(channel.name, message, (_) {});
  }

  setUp(() {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      calls.add(methodCall);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('passes plugins to createTracker', () async {
    await Snowplow.createTracker(namespace: 'ns1', endpoint: 'e1', plugins: [
      PluginConfiguration(identifier: 'p1', afterTrack: (_) {}),
      const PluginConfiguration(identifier: 'p2'),
    ]);

    expect(calls.single.method, equals('createTracker'));
    expect(
        calls.single.arguments['plugins'],
        equals([
          {'identifier': 'p1', 'afterTrack': true},
          {'identifier': 'p2'},
        ]));
  });

  test('calls afterTrack callback of plugin passed to createTracker', () async {
    final events = <InspectableEvent>[];
    await Snowplow.createTracker(namespace: 'ns1', endpoint: 'e1', plugins: [
      PluginConfiguration(identifier: 'p1', afterTrack: events.add)
    ]);

    await sendAfterTrack('ns1', 'p1', {
      'schema':
          'iglu:com.snowplowanalytics.snowplow/screen_view/jsonschema/1-0-0',
      'payload': {'name': 'home'},
      'entities': [
        {
          'schema': 'iglu:com.acme/entity/jsonschema/1-0-0',
          'data': {'a': 1}
        }
      ],
    });

    expect(events, hasLength(1));
    expect(events.single.schema,
        'iglu:com.snowplowanalytics.snowplow/screen_view/jsonschema/1-0-0');
    expect(events.single.name, isNull);
    expect(events.single.payload, equals({'name': 'home'}));
    expect(events.single.entities.single.schema,
        'iglu:com.acme/entity/jsonschema/1-0-0');
    expect(events.single.entities.single.data, equals({'a': 1}));
  });

  test('adds plugin at runtime', () async {
    final tracker =
        await Snowplow.createTracker(namespace: 'ns2', endpoint: 'e1');
    final events = <InspectableEvent>[];

    await tracker.addPlugin(
        PluginConfiguration(identifier: 'p1', afterTrack: events.add));
    await sendAfterTrack('ns2', 'p1', {
      'name': 'se',
      'payload': {'se_ca': 'c'}
    });

    expect(calls.last.method, equals('addPlugin'));
    expect(calls.last.arguments['tracker'], equals('ns2'));
    expect(calls.last.arguments['plugin'],
        equals({'identifier': 'p1', 'afterTrack': true}));
    expect(events.single.name, equals('se'));
    expect(events.single.payload, equals({'se_ca': 'c'}));
    expect(events.single.entities, isEmpty);
  });

  test('stops calling removed plugin', () async {
    final tracker =
        await Snowplow.createTracker(namespace: 'ns3', endpoint: 'e1');
    var count = 0;
    await tracker.addPlugin(
        PluginConfiguration(identifier: 'p1', afterTrack: (_) => count++));

    await tracker.removePlugin('p1');
    await sendAfterTrack('ns3', 'p1');

    expect(calls.last.method, equals('removePlugin'));
    expect(
        calls.last.arguments, equals({'tracker': 'ns3', 'identifier': 'p1'}));
    expect(count, equals(0));
  });

  test('calls only the plugin of the tracker that tracked the event', () async {
    var ns4Count = 0;
    var ns5Count = 0;
    await Snowplow.createTracker(namespace: 'ns4', endpoint: 'e1', plugins: [
      PluginConfiguration(identifier: 'p1', afterTrack: (_) => ns4Count++)
    ]);
    await Snowplow.createTracker(namespace: 'ns5', endpoint: 'e1', plugins: [
      PluginConfiguration(identifier: 'p1', afterTrack: (_) => ns5Count++)
    ]);

    await sendAfterTrack('ns5', 'p1');

    expect(ns4Count, equals(0));
    expect(ns5Count, equals(1));
  });

  test('replaces plugin with the same identifier', () async {
    final tracker =
        await Snowplow.createTracker(namespace: 'ns6', endpoint: 'e1');
    var firstCount = 0;
    var secondCount = 0;
    await tracker.addPlugin(
        PluginConfiguration(identifier: 'p1', afterTrack: (_) => firstCount++));

    await tracker.addPlugin(PluginConfiguration(
        identifier: 'p1', afterTrack: (_) => secondCount++));
    await sendAfterTrack('ns6', 'p1');

    expect(firstCount, equals(0));
    expect(secondCount, equals(1));
  });

  test('recreating tracker drops its previous plugins', () async {
    var count = 0;
    await Snowplow.createTracker(namespace: 'ns7', endpoint: 'e1', plugins: [
      PluginConfiguration(identifier: 'p1', afterTrack: (_) => count++)
    ]);

    await Snowplow.createTracker(namespace: 'ns7', endpoint: 'e1');
    await sendAfterTrack('ns7', 'p1');

    expect(count, equals(0));
  });
}
