import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/events.dart';
import 'package:snowplow_flutter_tracker/tracker.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';

void main() {
  const MethodChannel channel = MethodChannel('snowplow_flutter_tracker');
  String? method;
  dynamic arguments;
  Tracker? tracker;
  dynamic returnValue;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    returnValue = null;

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      method = methodCall.method;
      arguments = methodCall.arguments;
      return returnValue;
    });

    tracker = await Snowplow.createTracker(namespace: 'ns1', endpoint: 'e1');
    method = null;
    arguments = null;
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('tracks structured event', () async {
    await tracker
        ?.track(const Structured(category: 'category', action: 'action'));

    expect(method, equals('trackStructured'));
    expect(arguments['tracker'], equals('ns1'));
    expect(arguments['eventData']['category'], equals('category'));
  });

  test('sets user ID', () async {
    await tracker?.setUserId('XYZ');

    expect(method, equals('setUserId'));
    expect(arguments['tracker'], equals('ns1'));
    expect(arguments['userId'], equals('XYZ'));
  });

  test('gets session ID', () async {
    returnValue = '1234';
    String? sessionId = await tracker?.sessionId;

    expect(method, equals('getSessionId'));
    expect(arguments['tracker'], equals('ns1'));
    expect(sessionId, equals('1234'));
  });
}
