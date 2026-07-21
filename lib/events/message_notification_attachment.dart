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

/// Attachment included in a message notification.
///
/// {@category Tracking events}
@immutable
class MessageNotificationAttachment {
  /// Identifier of the attachment.
  final String identifier;

  /// MIME type of the attachment.
  final String type;

  /// URL of the attachment.
  final String url;

  const MessageNotificationAttachment({
    required this.identifier,
    required this.type,
    required this.url,
  });

  MessageNotificationAttachment.fromMap(Map<String, Object?> map)
      : identifier = map['identifier'] as String,
        type = map['type'] as String,
        url = map['url'] as String;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'identifier': identifier,
      'type': type,
      'url': url,
    };
  }
}
