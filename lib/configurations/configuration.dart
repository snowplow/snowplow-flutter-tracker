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
import 'package:snowplow_flutter_tracker/configurations/gdpr_configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/network_configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/subject_configuration.dart';
import 'package:snowplow_flutter_tracker/configurations/tracker_configuration.dart';

@immutable
class Configuration {
  final String namespace;
  final NetworkConfiguration networkConfig;
  final TrackerConfiguration? trackerConfig;
  final SubjectConfiguration? subjectConfig;
  final GdprConfiguration? gdprConfig;

  const Configuration(
      {required this.namespace,
      required this.networkConfig,
      this.trackerConfig,
      this.subjectConfig,
      this.gdprConfig});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'namespace': namespace,
      'networkConfig': networkConfig.toMap(),
      'trackerConfig': trackerConfig?.toMap(),
      'subjectConfig': subjectConfig?.toMap(),
      'gdprConfig': gdprConfig?.toMap()
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
