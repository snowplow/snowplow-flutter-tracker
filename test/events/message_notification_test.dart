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
  test('MessageNotification endpoint returns correct value', () {
    const event =
        MessageNotification(title: 'Title', body: 'Body', trigger: 'push');
    expect(event.endpoint(), equals('trackMessageNotification'));
  });

  test('MessageNotification toMap includes required fields', () {
    const event =
        MessageNotification(title: 'Title', body: 'Body', trigger: 'push');
    final map = event.toMap();

    expect(map['title'], equals('Title'));
    expect(map['body'], equals('Body'));
    expect(map['trigger'], equals('push'));
  });

  test('MessageNotification toMap omits null optional fields', () {
    const event =
        MessageNotification(title: 'Title', body: 'Body', trigger: 'push');
    final map = event.toMap();

    expect(map.containsKey('action'), isFalse);
    expect(map.containsKey('attachments'), isFalse);
    expect(map.containsKey('bodyLocArgs'), isFalse);
    expect(map.containsKey('bodyLocKey'), isFalse);
    expect(map.containsKey('category'), isFalse);
    expect(map.containsKey('contentAvailable'), isFalse);
    expect(map.containsKey('group'), isFalse);
    expect(map.containsKey('icon'), isFalse);
    expect(map.containsKey('notificationCount'), isFalse);
    expect(map.containsKey('notificationTimestamp'), isFalse);
    expect(map.containsKey('sound'), isFalse);
    expect(map.containsKey('subtitle'), isFalse);
    expect(map.containsKey('tag'), isFalse);
    expect(map.containsKey('threadIdentifier'), isFalse);
    expect(map.containsKey('titleLocArgs'), isFalse);
    expect(map.containsKey('titleLocKey'), isFalse);
  });

  test('MessageNotification toMap includes all optional fields when set', () {
    const attachment = MessageNotificationAttachment(
      identifier: 'att1',
      type: 'image/png',
      url: 'https://example.com/image.png',
    );
    const event = MessageNotification(
      title: 'Title',
      body: 'Body',
      trigger: 'calendar',
      action: 'Open',
      attachments: [attachment],
      bodyLocArgs: ['bodyArg'],
      bodyLocKey: 'bodyKey',
      category: 'cat1',
      contentAvailable: true,
      group: 'group1',
      icon: 'icon1',
      notificationCount: 5,
      notificationTimestamp: '2023-01-01T00:00:00Z',
      sound: 'default',
      subtitle: 'Subtitle',
      tag: 'tag1',
      threadIdentifier: 'thread1',
      titleLocArgs: ['titleArg'],
      titleLocKey: 'titleKey',
    );
    final map = event.toMap();

    expect(map['title'], equals('Title'));
    expect(map['body'], equals('Body'));
    expect(map['trigger'], equals('calendar'));
    expect(map['action'], equals('Open'));
    expect(map['bodyLocArgs'], equals(['bodyArg']));
    expect(map['bodyLocKey'], equals('bodyKey'));
    expect(map['category'], equals('cat1'));
    expect(map['contentAvailable'], equals(true));
    expect(map['group'], equals('group1'));
    expect(map['icon'], equals('icon1'));
    expect(map['notificationCount'], equals(5));
    expect(map['notificationTimestamp'], equals('2023-01-01T00:00:00Z'));
    expect(map['sound'], equals('default'));
    expect(map['subtitle'], equals('Subtitle'));
    expect(map['tag'], equals('tag1'));
    expect(map['threadIdentifier'], equals('thread1'));
    expect(map['titleLocArgs'], equals(['titleArg']));
    expect(map['titleLocKey'], equals('titleKey'));

    final attachments = map['attachments'] as List;
    expect(attachments.length, equals(1));
    expect(attachments[0]['identifier'], equals('att1'));
    expect(attachments[0]['type'], equals('image/png'));
    expect(attachments[0]['url'], equals('https://example.com/image.png'));
  });

  test('MessageNotificationAttachment toMap includes all fields', () {
    const attachment = MessageNotificationAttachment(
      identifier: 'att1',
      type: 'image/png',
      url: 'https://example.com/image.png',
    );
    final map = attachment.toMap();

    expect(map['identifier'], equals('att1'));
    expect(map['type'], equals('image/png'));
    expect(map['url'], equals('https://example.com/image.png'));
  });
}
