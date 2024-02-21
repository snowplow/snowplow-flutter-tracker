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

import 'package:snowplow_tracker/events/page_view_event.dart';
import 'event_reader.dart';

class PageViewEventReader extends PageViewEvent implements EventReader {
  PageViewEventReader(dynamic map) : super(title: map['title']);

  @override
  String endpoint() {
    return 'trackPageView';
  }

  @override
  Map eventData() {
    final data = {'title': title};
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
