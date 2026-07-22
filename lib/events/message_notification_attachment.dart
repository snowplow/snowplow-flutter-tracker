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

/// Attachment included in a push notification (used with [MessageNotification]).
///
/// {@category Tracking events}
@immutable
class MessageNotificationAttachment {
  /// The attachment identifier.
  final String identifier;

  /// The attachment MIME type.
  final String type;

  /// The attachment URL.
  final String url;

  const MessageNotificationAttachment({
    required this.identifier,
    required this.type,
    required this.url,
  });

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'identifier': identifier,
      'type': type,
      'url': url,
    };
  }
}
