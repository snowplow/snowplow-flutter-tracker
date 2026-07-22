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

/// Event to track a push notification message received by the app.
///
/// Mobile only (not supported on Web).
///
/// The [trigger] field should be one of: 'push', 'location', 'calendar',
/// 'timeInterval'.
///
/// {@category Tracking events}
@immutable
class MessageNotification implements Event {
  /// The notification's title text.
  final String title;

  /// The notification's body text.
  final String body;

  /// The trigger that caused the notification to be delivered.
  /// One of: 'push', 'location', 'calendar', 'timeInterval'.
  final String trigger;

  /// The time (ISO-8601) at which the notification was delivered.
  final String? notificationTimestamp;

  /// The category identifier for the notification.
  final String? categoryIdentifier;

  /// The identifier for the thread or conversation related to the notification.
  final String? threadIdentifier;

  /// The notification's subtitle text.
  final String? subtitle;

  /// The app icon badge count.
  final int? badge;

  /// The name of the sound associated with the notification.
  final String? sound;

  /// The image name to use as the launch image.
  final String? launchImageName;

  /// The action associated with the notification.
  final String? action;

  /// An array of attachments included in the notification.
  final List<MessageNotificationAttachment>? attachments;

  const MessageNotification({
    required this.title,
    required this.body,
    required this.trigger,
    this.notificationTimestamp,
    this.categoryIdentifier,
    this.threadIdentifier,
    this.subtitle,
    this.badge,
    this.sound,
    this.launchImageName,
    this.action,
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
      'notificationTimestamp': notificationTimestamp,
      'categoryIdentifier': categoryIdentifier,
      'threadIdentifier': threadIdentifier,
      'subtitle': subtitle,
      'badge': badge,
      'sound': sound,
      'launchImageName': launchImageName,
      'action': action,
      'attachments': attachments?.map((a) => a.toMap()).toList(),
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
