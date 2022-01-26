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

import 'event_reader.dart';
import 'package:snowplow_tracker/events/consent_withdrawn.dart';

class ConsentWithdrawnReader extends ConsentWithdrawn implements EventReader {
  ConsentWithdrawnReader(dynamic map)
      : super(
            all: map['all'],
            documentId: map['documentId'],
            version: map['version'],
            name: map['name'],
            documentDescription: map['documentDescription']);

  @override
  String endpoint() {
    return 'trackConsentWithdrawn';
  }

  @override
  Map eventData() {
    return {
      'all': all,
      'id': documentId,
      'version': version,
      'name': name,
      'description': documentDescription
    };
  }
}
