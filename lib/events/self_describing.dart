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

import 'package:snowplow_flutter_tracker/events/event.dart';

/// Event to track custom information that does not fit into the out-of-the box events.
///
/// Self-describing events are a [data structure based on JSON Schemas](https://docs.snowplowanalytics.com/docs/understanding-tracking-design/understanding-schemas-and-validation/) and can have arbitrarily many fields.
/// To define your own custom self-describing event, you must create a JSON schema for that event and upload it to an [Iglu Schema Repository](https://github.com/snowplow/iglu) using [igluctl](https://docs.snowplowanalytics.com/docs/open-source-components-and-applications/iglu/) (or if a Snowplow BDP customer, you can use the [Snowplow BDP Console UI](https://docs.snowplowanalytics.com/docs/understanding-tracking-design/managing-data-structures/) or [Data Structures API](https://docs.snowplowanalytics.com/docs/understanding-tracking-design/managing-data-structures-via-the-api-2/)).
/// Snowplow uses the schema to validate that the JSON containing the event properties is well-formed.
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class SelfDescribing implements Event {
  /// A valid Iglu schema path.
  ///
  /// This must point to the location of the custom event’s schema, of the format: `iglu:{vendor}/{name}/{format}/{version}`.
  final String schema;

  /// The custom data for the event.
  ///
  /// This data must conform to the schema specified in the schema argument, or the event will fail validation and land in bad rows.
  final dynamic data;

  const SelfDescribing({required this.schema, required this.data});

  @override
  String endpoint() {
    return 'trackSelfDescribing';
  }

  @override
  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      'schema': schema,
      'data': data,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
