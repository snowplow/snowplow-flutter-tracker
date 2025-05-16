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

import 'package:flutter/foundation.dart';

enum BufferOption {
  single,
  defaultGroup,
  largeGroup,
}

/// Configuration of the event emitter.
///
/// {@category Initialization and configuration}
@immutable
class EmitterConfiguration {
  final bool? serverAnonymisation;

  final BufferOption? bufferOption;

  final int? emitRange;

  final int? threadPoolSize;

  final int? maxEventStore;

  final List<int>? customRetryForStatusCodes;

  final int? maxEventAgeSeconds;
  final bool? retryFailedRequests;
  const EmitterConfiguration({
    this.serverAnonymisation,
    this.bufferOption,
    this.emitRange,
    this.threadPoolSize,
    this.maxEventStore,
    this.customRetryForStatusCodes,
    this.maxEventAgeSeconds,
    this.retryFailedRequests,
  });

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'serverAnonymisation': serverAnonymisation,
      'bufferOption': bufferOption?.name,
      'emitRange': emitRange,
      'threadPoolSize': threadPoolSize,
      'maxEventStore': maxEventStore,
      'customRetryForStatusCodes': customRetryForStatusCodes,
      'maxEventAgeSeconds': maxEventAgeSeconds,
      'retryFailedRequests': retryFailedRequests,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
