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
        MessageNotification(title: 'T', body: 'B', trigger: 'push');
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

  test('MessageNotification toMap removes null optional fields', () {
    const event =
        MessageNotification(title: 'T', body: 'B', trigger: 'push');
    final map = event.toMap();
    expect(map.containsKey('action'), isFalse);
    expect(map.containsKey('attachments'), isFalse);
    expect(map.containsKey('categoryIdentifier'), isFalse);
    expect(map.containsKey('badge'), isFalse);
    expect(map.containsKey('launchImageName'), isFalse);
    expect(map.containsKey('notificationTimestamp'), isFalse);
    expect(map.containsKey('sound'), isFalse);
    expect(map.containsKey('subtitle'), isFalse);
    expect(map.containsKey('thread'), isFalse);
  });

  test('MessageNotification toMap includes all optional fields when set', () {
    final attachment = const MessageNotificationAttachment(
      identifier: 'id1',
      type: 'image/png',
      url: 'https://example.com/image.png',
    );
    final event = MessageNotification(
      title: 'Title',
      body: 'Body',
      trigger: 'push',
      action: 'Open',
      attachments: [attachment],
      categoryIdentifier: 'cat1',
      badge: 5,
      launchImageName: 'launch',
      notificationTimestamp: '2021-01-01T00:00:00.000Z',
      sound: 'default',
      subtitle: 'Sub',
      thread: 'thread1',
    );
    final map = event.toMap();
    expect(map['action'], equals('Open'));
    expect(map['categoryIdentifier'], equals('cat1'));
    expect(map['badge'], equals(5));
    expect(map['launchImageName'], equals('launch'));
    expect(map['notificationTimestamp'], equals('2021-01-01T00:00:00.000Z'));
    expect(map['sound'], equals('default'));
    expect(map['subtitle'], equals('Sub'));
    expect(map['thread'], equals('thread1'));
    final attachments = map['attachments'] as List;
    expect(attachments.length, equals(1));
    expect(attachments[0]['identifier'], equals('id1'));
  });

  test('MessageNotification fromMap round-trip with required fields only', () {
    const original =
        MessageNotification(title: 'T', body: 'B', trigger: 'location');
    final restored = MessageNotification.fromMap(original.toMap());
    expect(restored.title, equals(original.title));
    expect(restored.body, equals(original.body));
    expect(restored.trigger, equals(original.trigger));
    expect(restored.attachments, isNull);
  });

  test('MessageNotification fromMap round-trip preserves attachments', () {
    const attachment = MessageNotificationAttachment(
      identifier: 'att1',
      type: 'video/mp4',
      url: 'https://example.com/video.mp4',
    );
    const original = MessageNotification(
      title: 'T',
      body: 'B',
      trigger: 'push',
      attachments: [attachment],
    );
    final map = original.toMap();
    final restored = MessageNotification.fromMap(map);
    expect(restored.attachments, isNotNull);
    expect(restored.attachments!.length, equals(1));
    expect(restored.attachments![0].identifier, equals('att1'));
    expect(restored.attachments![0].type, equals('video/mp4'));
    expect(restored.attachments![0].url,
        equals('https://example.com/video.mp4'));
  });

  test(
      'MessageNotificationAttachment toMap and fromMap round-trip',
      () {
    const attachment = MessageNotificationAttachment(
      identifier: 'id1',
      type: 'image/png',
      url: 'https://example.com/image.png',
    );
    final map = attachment.toMap();
    final restored = MessageNotificationAttachment.fromMap(map);
    expect(restored.identifier, equals(attachment.identifier));
    expect(restored.type, equals(attachment.type));
    expect(restored.url, equals(attachment.url));
  });

  test('MessageNotification toMap attachment round-trip equality', () {
    const attachment = MessageNotificationAttachment(
      identifier: 'id1',
      type: 'image/png',
      url: 'https://example.com/image.png',
    );
    const original = MessageNotification(
      title: 'T',
      body: 'B',
      trigger: 'push',
      attachments: [attachment],
    );
    final map1 = original.toMap();
    final restored = MessageNotification.fromMap(map1);
    final map2 = restored.toMap();
    expect(map1['attachments'], equals(map2['attachments']));
  });
}
