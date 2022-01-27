// Copyright (c) 2022 Snowplow Analytics Ltd. All rights reserved.
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

/// Event to capture page views on the Web. Not implemented on mobile platforms.
///
/// Page views automatically capture URL, referrer and page title.
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class PageViewEvent implements Event {
  /// Optional title to replace the one automatically inferred from page title attribute.
  final String? title;

  const PageViewEvent({this.title});

  @override
  String endpoint() {
    return 'trackPageView';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{'title': title};
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
