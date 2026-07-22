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

/// Event to track a deep link being received by the app.
///
/// Not supported on Web.
///
/// {@category Tracking events}
@immutable
class DeepLinkReceived implements Event {
  /// The URL of the deep link.
  final String url;

  /// The referrer URL.
  final String? referrer;

  const DeepLinkReceived({required this.url, this.referrer});

  DeepLinkReceived.fromMap(Map<String, Object?> map)
      : url = map['url'] as String,
        referrer = map['referrer'] as String?;

  @override
  String endpoint() {
    return 'trackDeepLinkReceived';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'url': url,
      'referrer': referrer,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
