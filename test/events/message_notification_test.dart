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
import 'package:snowplow_tracker/events/message_notification.dart';
import 'package:snowplow_tracker/events/message_notification_attachment.dart';

void main() {
  test('MessageNotification toMap includes required fields', () {
    const event = MessageNotification(
      title: 'Test Title',
      body: 'Test body',
      trigger: 'push',
    );
    final map = event.toMap();

    expect(map['title'], equals('Test Title'));
    expect(map['body'], equals('Test body'));
    expect(map['trigger'], equals('push'));
  });

  test('MessageNotification toMap excludes null optional fields', () {
    const event = MessageNotification(
      title: 'Test',
      body: 'Body',
      trigger: 'push',
    );
    final map = event.toMap();

    expect(map.containsKey('notificationTimestamp'), isFalse);
    expect(map.containsKey('categoryIdentifier'), isFalse);
    expect(map.containsKey('threadIdentifier'), isFalse);
    expect(map.containsKey('subtitle'), isFalse);
    expect(map.containsKey('badge'), isFalse);
    expect(map.containsKey('sound'), isFalse);
    expect(map.containsKey('launchImageName'), isFalse);
    expect(map.containsKey('action'), isFalse);
    expect(map.containsKey('attachments'), isFalse);
  });

  test('MessageNotification toMap includes all optional fields when set', () {
    final attachment = const MessageNotificationAttachment(
      identifier: 'att1',
      type: 'image/png',
      url: 'https://example.com/img.png',
    );
    final event = MessageNotification(
      title: 'Title',
      body: 'Body',
      trigger: 'push',
      notificationTimestamp: '2023-01-01T00:00:00.000Z',
      categoryIdentifier: 'cat1',
      threadIdentifier: 'thread1',
      subtitle: 'Subtitle',
      badge: 5,
      sound: 'sound.wav',
      launchImageName: 'launch.png',
      action: 'click',
      attachments: [attachment],
    );
    final map = event.toMap();

    expect(map['notificationTimestamp'], equals('2023-01-01T00:00:00.000Z'));
    expect(map['categoryIdentifier'], equals('cat1'));
    expect(map['threadIdentifier'], equals('thread1'));
    expect(map['subtitle'], equals('Subtitle'));
    expect(map['badge'], equals(5));
    expect(map['sound'], equals('sound.wav'));
    expect(map['launchImageName'], equals('launch.png'));
    expect(map['action'], equals('click'));
    expect(map['attachments'], isList);
    expect((map['attachments'] as List).length, equals(1));
  });

  test('MessageNotification endpoint returns correct value', () {
    const event = MessageNotification(
      title: 'T',
      body: 'B',
      trigger: 'push',
    );
    expect(event.endpoint(), equals('trackMessageNotification'));
  });

  test('MessageNotificationAttachment toMap serializes correctly', () {
    const attachment = MessageNotificationAttachment(
      identifier: 'id1',
      type: 'image/png',
      url: 'https://example.com/img.png',
    );
    final map = attachment.toMap();

    expect(map['identifier'], equals('id1'));
    expect(map['type'], equals('image/png'));
    expect(map['url'], equals('https://example.com/img.png'));
  });

  test('MessageNotification attachment maps are serialized in toMap', () {
    const event = MessageNotification(
      title: 'T',
      body: 'B',
      trigger: 'push',
      attachments: [
        MessageNotificationAttachment(
          identifier: 'id1',
          type: 'image/png',
          url: 'https://example.com/img.png',
        ),
      ],
    );
    final map = event.toMap();
    final attachments = map['attachments'] as List;

    expect(attachments.length, equals(1));
    expect((attachments[0] as Map)['identifier'], equals('id1'));
    expect((attachments[0] as Map)['type'], equals('image/png'));
    expect((attachments[0] as Map)['url'], equals('https://example.com/img.png'));
  });
}
