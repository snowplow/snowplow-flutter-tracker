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
import 'package:snowplow_tracker/events/message_notification_trigger.dart';

/// Event to track a push notification or similar message.
///
/// Not supported on Web.
/// {@category Tracking events}
@immutable
class MessageNotification implements Event {
  /// The notification's title.
  final String title;

  /// The notification's body.
  final String body;

  /// The trigger that caused the notification to be delivered.
  final MessageNotificationTrigger trigger;

  /// The action associated with the notification.
  final String? action;

  /// Attachments added to the notification.
  final List<MessageNotificationAttachment>? attachments;

  /// Variable string values to appear in place of the format specifiers in [bodyLocKey].
  final List<String>? bodyLocArgs;

  /// The key for the localized body string.
  final String? bodyLocKey;

  /// The category of the notification.
  final String? category;

  /// Indicates whether notification content can be modified before delivery.
  final bool? contentAvailable;

  /// The group of the notification.
  final String? group;

  /// The icon of the notification.
  final String? icon;

  /// The number to display on the app icon badge.
  final int? notificationCount;

  /// The ISO 8601 timestamp when the notification was delivered.
  final String? notificationTimestamp;

  /// The sound played when the device receives the notification.
  final String? sound;

  /// A subtitle providing additional context.
  final String? subtitle;

  /// An identifier similar to the thread identifier.
  final String? tag;

  /// An identifier for grouping related notifications.
  final String? threadIdentifier;

  /// Variable string values for [titleLocKey].
  final List<String>? titleLocArgs;

  /// The key for the localized title string.
  final String? titleLocKey;

  const MessageNotification({
    required this.title,
    required this.body,
    required this.trigger,
    this.action,
    this.attachments,
    this.bodyLocArgs,
    this.bodyLocKey,
    this.category,
    this.contentAvailable,
    this.group,
    this.icon,
    this.notificationCount,
    this.notificationTimestamp,
    this.sound,
    this.subtitle,
    this.tag,
    this.threadIdentifier,
    this.titleLocArgs,
    this.titleLocKey,
  });

  @override
  String endpoint() {
    return 'trackMessageNotification';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'title': title,
      'body': body,
      'trigger': trigger.name,
      'action': action,
      'attachments': attachments?.map((a) => a.toMap()).toList(),
      'bodyLocArgs': bodyLocArgs,
      'bodyLocKey': bodyLocKey,
      'category': category,
      'contentAvailable': contentAvailable,
      'group': group,
      'icon': icon,
      'notificationCount': notificationCount,
      'notificationTimestamp': notificationTimestamp,
      'sound': sound,
      'subtitle': subtitle,
      'tag': tag,
      'threadIdentifier': threadIdentifier,
      'titleLocArgs': titleLocArgs,
      'titleLocKey': titleLocKey,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
