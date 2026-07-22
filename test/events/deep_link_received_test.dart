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
  test('DeepLinkReceived toMap includes required url', () {
    const event = DeepLinkReceived(url: 'https://example.com');
    final map = event.toMap();

    expect(map['url'], equals('https://example.com'));
  });

  test('DeepLinkReceived toMap excludes null referrer', () {
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

  test('DeepLinkReceived fromMap populates all fields', () {
    final map = {
      'url': 'https://example.com',
      'referrer': 'https://referrer.com',
    };
    final event = DeepLinkReceived.fromMap(map);
    final result = event.toMap();

    expect(result['url'], equals('https://example.com'));
    expect(result['referrer'], equals('https://referrer.com'));
  });

  test('DeepLinkReceived fromMap handles missing referrer', () {
    final map = {'url': 'https://example.com'};
    final event = DeepLinkReceived.fromMap(map);
    final result = event.toMap();

    expect(result['url'], equals('https://example.com'));
    expect(result.containsKey('referrer'), isFalse);
  });

  test('DeepLinkReceived endpoint returns correct value', () {
    const event = DeepLinkReceived(url: 'https://example.com');
    expect(event.endpoint(), equals('trackDeepLinkReceived'));
  });
}
