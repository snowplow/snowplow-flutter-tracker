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

/// Event used to track a user opting into data collection.
///
/// A consent document context will be attached to the event using the [documentId] and [version] arguments supplied.
/// {@category Events}
@immutable
class ConsentGranted implements Event {
  /// The expiry (date-time string, e.g.: "2022-01-01T00:00:00Z")
  final String expiry;

  /// The consent document ID.
  final String documentId;

  /// The consent document version.
  final String version;

  /// Optional consent document name.
  final String? name;

  /// Optional consent document description.
  final String? documentDescription;

  const ConsentGranted(
      {required this.expiry,
      required this.documentId,
      required this.version,
      this.name,
      this.documentDescription});

  @override
  String endpoint() {
    return 'trackConsentGranted';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'expiry': expiry,
      'documentId': documentId,
      'version': version,
      'name': name,
      'documentDescription': documentDescription
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
