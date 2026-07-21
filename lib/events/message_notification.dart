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

import 'package:flutter/foundation.dart';

import 'package:snowplow_tracker/events/event.dart';
import 'package:snowplow_tracker/events/message_notification_attachment.dart';

/// Event to track a push or local notification received by the app.
///
/// This event is not supported on Web.
///
/// {@category Tracking events}
@immutable
class MessageNotification implements Event {
  /// Title of the notification.
  final String title;

  /// Body of the notification.
  final String body;

  /// The trigger that caused the notification to be delivered. One of:
  /// 'push', 'location', 'calendar', 'timeInterval', 'other'.
  final String trigger;

  /// Optional notification action.
  final String? action;

  /// Attachments included in the notification.
  final List<MessageNotificationAttachment>? attachments;

  /// Identifier of the notification's category.
  final String? categoryIdentifier;

  /// The application badge count set by the notification.
  final int? badge;

  /// Name of the image or storyboard to use when your app launches.
  final String? launchImageName;

  /// Timestamp when the notification was delivered.
  final String? notificationTimestamp;

  /// Sound name for the notification.
  final String? sound;

  /// Subtitle of the notification.
  final String? subtitle;

  /// Thread identifier for visually grouping notifications.
  final String? thread;

  const MessageNotification({
    required this.title,
    required this.body,
    required this.trigger,
    this.action,
    this.attachments,
    this.categoryIdentifier,
    this.badge,
    this.launchImageName,
    this.notificationTimestamp,
    this.sound,
    this.subtitle,
    this.thread,
  });

  MessageNotification.fromMap(Map<String, Object?> map)
      : title = map['title'] as String,
        body = map['body'] as String,
        trigger = map['trigger'] as String,
        action = map['action'] as String?,
        attachments = (map['attachments'] as List<Object?>?)
            ?.map((e) => MessageNotificationAttachment.fromMap(
                e as Map<String, Object?>))
            .toList(),
        categoryIdentifier = map['categoryIdentifier'] as String?,
        badge = map['badge'] as int?,
        launchImageName = map['launchImageName'] as String?,
        notificationTimestamp = map['notificationTimestamp'] as String?,
        sound = map['sound'] as String?,
        subtitle = map['subtitle'] as String?,
        thread = map['thread'] as String?;

  @override
  String endpoint() {
    return 'trackMessageNotification';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'title': title,
      'body': body,
      'trigger': trigger,
      'action': action,
      'attachments': attachments?.map((a) => a.toMap()).toList(),
      'categoryIdentifier': categoryIdentifier,
      'badge': badge,
      'launchImageName': launchImageName,
      'notificationTimestamp': notificationTimestamp,
      'sound': sound,
      'subtitle': subtitle,
      'thread': thread,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
