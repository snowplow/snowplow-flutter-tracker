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

  /// The badge count of the application.
  final int? badge;

  /// The category identifier of the notification.
  final String? categoryIdentifier;

  /// The name of the launch image used when the app is launched.
  final String? launchImageName;

  /// The date and time the notification was sent.
  final String? notificationTimestamp;

  /// The sound of the notification.
  final String? sound;

  /// The subtitle of the notification.
  final String? subtitle;

  /// The thread identifier of the notification.
  final String? threadIdentifier;

  /// The attachments included in the notification.
  final List<MessageNotificationAttachment>? attachments;

  const MessageNotification({
    required this.title,
    required this.body,
    required this.trigger,
    this.action,
    this.badge,
    this.categoryIdentifier,
    this.launchImageName,
    this.notificationTimestamp,
    this.sound,
    this.subtitle,
    this.threadIdentifier,
    this.attachments,
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
      'badge': badge,
      'categoryIdentifier': categoryIdentifier,
      'launchImageName': launchImageName,
      'notificationTimestamp': notificationTimestamp,
      'sound': sound,
      'subtitle': subtitle,
      'threadIdentifier': threadIdentifier,
      'attachments': attachments?.map((a) => a.toMap()).toList(),
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
