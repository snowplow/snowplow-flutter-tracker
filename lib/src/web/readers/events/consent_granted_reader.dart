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

import 'package:snowplow_tracker/events/consent_granted.dart';
import 'event_reader.dart';

class ConsentGrantedReader extends ConsentGranted implements EventReader {
  ConsentGrantedReader(dynamic map)
      : super(
            expiry: DateTime.parse(map['expiry']),
            documentId: map['documentId'],
            version: map['version'],
            name: map['name'],
            documentDescription: map['documentDescription']);

  @override
  String endpoint() {
    return 'trackConsentGranted';
  }

  @override
  Map eventData() {
    return {
      'id': documentId,
      'version': version,
      'name': name,
      'description': documentDescription,
      'expiry': expiry.toIso8601String()
    };
  }
}
