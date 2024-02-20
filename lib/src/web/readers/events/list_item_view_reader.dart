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

import 'package:snowplow_tracker/events/list_item_view.dart';
import 'event_reader.dart';

class ListItemViewReader extends ListItemView implements EventReader {
  ListItemViewReader(dynamic map)
      : super(index: map['index'], itemsCount: map['itemsCount']);

  @override
  String endpoint() {
    return 'trackSelfDescribingEvent';
  }

  @override
  Map eventData() {
    var data = {
      'index': index,
      'items_count': itemsCount,
    };
    data.removeWhere((key, value) => value == null);
    return {
      'event': {
        'schema':
            'iglu:com.snowplowanalytics.mobile/list_item_view/jsonschema/1-0-0',
        'data': data
      }
    };
  }
}
