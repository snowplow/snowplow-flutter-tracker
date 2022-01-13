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

/// Event to track a user withdrawing consent for data collection.
///
/// A consent document context will be attached to the event using the id and version arguments supplied.
/// To specify that a user opts out of all data collection, [all] should be set to true.
/// {@category Events}
@immutable
class ConsentWithdrawn implements Event {
  /// Whether user opts out of all data collection.
  final bool all;

  /// The consent document ID.
  final String documentId;

  /// The consent document version.
  final String version;

  /// Optional consent document name.
  final String? name;

  /// Optional consent document description.
  final String? documentDescription;

  const ConsentWithdrawn(
      {required this.all,
      required this.documentId,
      required this.version,
      this.name,
      this.documentDescription});

  @override
  String endpoint() {
    return 'trackConsentWithdrawn';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'all': all,
      'documentId': documentId,
      'version': version,
      'name': name,
      'documentDescription': documentDescription
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
