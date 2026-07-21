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
import 'package:snowplow_tracker/events/deep_link_received.dart';

void main() {
  test('DeepLinkReceived endpoint returns correct value', () {
    const event = DeepLinkReceived(url: 'https://example.com');
    expect(event.endpoint(), equals('trackDeepLinkReceived'));
  });

  test('DeepLinkReceived toMap includes required url field', () {
    const event = DeepLinkReceived(url: 'https://example.com');
    final map = event.toMap();
    expect(map['url'], equals('https://example.com'));
  });

  test('DeepLinkReceived toMap removes null referrer', () {
    const event = DeepLinkReceived(url: 'https://example.com');
    final map = event.toMap();
    expect(map.containsKey('referrer'), isFalse);
  });

  test('DeepLinkReceived toMap includes referrer when set', () {
    const event = DeepLinkReceived(
      url: 'https://example.com',
      referrer: 'https://referrer.com',
    );
    final map = event.toMap();
    expect(map['url'], equals('https://example.com'));
    expect(map['referrer'], equals('https://referrer.com'));
  });

  test('DeepLinkReceived fromMap round-trip with url only', () {
    const original = DeepLinkReceived(url: 'https://example.com');
    final restored = DeepLinkReceived.fromMap(original.toMap());
    expect(restored.url, equals(original.url));
    expect(restored.referrer, isNull);
  });

  test('DeepLinkReceived fromMap round-trip with referrer', () {
    const original = DeepLinkReceived(
      url: 'https://example.com',
      referrer: 'https://referrer.com',
    );
    final restored = DeepLinkReceived.fromMap(original.toMap());
    expect(restored.url, equals(original.url));
    expect(restored.referrer, equals(original.referrer));
  });
}
