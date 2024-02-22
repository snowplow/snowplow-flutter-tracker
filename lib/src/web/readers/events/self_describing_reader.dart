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

import 'package:snowplow_tracker/events/self_describing.dart';
import 'event_reader.dart';

class SelfDescribingReader extends SelfDescribing implements EventReader {
  SelfDescribingReader(dynamic map)
      : super(schema: map['schema'], data: map['data']);

  @override
  String endpoint() {
    return 'trackSelfDescribingEvent';
  }

  Map json() {
    return {'schema': schema, 'data': data};
  }

  @override
  Map eventData() {
    return {'event': json()};
  }
}
