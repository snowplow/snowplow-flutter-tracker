import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';

void main() {
  const MethodChannel channel = MethodChannel('snowplow_flutter_tracker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 10;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('mockedMethodCall', () async {
    expect(await Snowplow.getSessionIndex(tracker: 'test'), 10);
  });
}
