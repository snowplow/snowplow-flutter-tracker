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

import 'package:snowplow_tracker/events/scroll_changed.dart';
import 'event_reader.dart';

class ScrollChangedReader extends ScrollChanged implements EventReader {
  ScrollChangedReader(dynamic map)
      : super(
            yOffset: map['yOffset'],
            xOffset: map['xOffset'],
            viewHeight: map['viewHeight'],
            viewWidth: map['viewWidth'],
            contentHeight: map['contentHeight'],
            contentWidth: map['contentWidth']);

  @override
  String endpoint() {
    return 'trackSelfDescribingEvent';
  }

  @override
  Map eventData() {
    var data = {
      'y_offset': yOffset,
      'x_offset': xOffset,
      'view_height': viewHeight,
      'view_width': viewWidth,
      'content_height': contentHeight,
      'content_width': contentWidth
    };
    data.removeWhere((key, value) => value == null);
    return {
      'event': {
        'schema':
            'iglu:com.snowplowanalytics.mobile/scroll_changed/jsonschema/1-0-0',
        'data': data
      }
    };
  }
}
