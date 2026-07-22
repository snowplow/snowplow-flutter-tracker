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

/// Event to track a push notification (mobile only).
///
/// The [trigger] field indicates the trigger type: one of 'push', 'calendar',
/// 'timeInterval', or 'location'.
///
/// {@category Tracking events}
@immutable
class MessageNotification implements Event {
  /// The notification title.
  final String title;

  /// The notification body.
  final String body;

  /// The trigger that caused the notification to be delivered.
  final String trigger;

  /// The action associated with the notification.
  final String? action;

  /// Attachments added to the notification (they can be part of the data
  /// object).
  final List<MessageNotificationAttachment>? attachments;

  /// Variable string values to be used in place of the format specifiers in
  /// [bodyLocKey] to localize the body text to the user's current
  /// localization.
  final List<String>? bodyLocArgs;

  /// The key to the body string in the app's string resources to use to
  /// localize the body text to the user's current localization.
  final String? bodyLocKey;

  /// The category associated with the notification.
  final String? category;

  /// Whether the app is notified of the delivery of the notification while in
  /// the foreground or background (iOS only).
  final bool? contentAvailable;

  /// The group which this notification is part of.
  final String? group;

  /// The icon associated with the notification (Android only).
  final String? icon;

  /// The number of items this notification represents.
  final int? notificationCount;

  /// The time when the notification was delivered.
  final String? notificationTimestamp;

  /// The sound played when the device receives the notification.
  final String? sound;

  /// The notification's subtitle.
  final String? subtitle;

  /// An identifier for the notification, used to replace or group
  /// notifications (Android only).
  final String? tag;

  /// The thread identifier the notification belongs to (iOS only).
  final String? threadIdentifier;

  /// Variable string values to be used in place of the format specifiers in
  /// [titleLocKey] to localize the title text to the user's current
  /// localization.
  final List<String>? titleLocArgs;

  /// The key to the title string in the app's string resources to use to
  /// localize the title text to the user's current localization.
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
      'trigger': trigger,
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
