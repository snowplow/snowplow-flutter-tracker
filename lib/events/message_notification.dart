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

/// Event to track a push notification or local notification being received.
///
/// Not supported on Web.
///
/// {@category Tracking events}
@immutable
class MessageNotification implements Event {
  /// The notification title.
  final String title;

  /// The notification body.
  final String body;

  /// The trigger that caused the notification to be delivered.
  final MessageNotificationTrigger trigger;

  final String? action;
  final List<MessageNotificationAttachment>? attachments;
  final List<String>? bodyLocArgs;
  final String? bodyLocKey;
  final String? category;
  final bool? contentAvailable;
  final String? group;
  final String? icon;
  final int? notificationCount;
  final String? notificationTimestamp;
  final String? sound;
  final String? subtitle;
  final String? tag;
  final String? threadIdentifier;
  final List<String>? titleLocArgs;
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
      'trigger': trigger.toValue(),
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
