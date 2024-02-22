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

import 'package:snowplow_tracker/configurations/configuration.dart';
import 'gdpr_configuration_reader.dart';
import 'network_configuration_reader.dart';
import 'subject_configuration_reader.dart';
import 'tracker_configuration_reader.dart';
import 'emitter_configuration_reader.dart';

class ConfigurationReader extends Configuration {
  ConfigurationReader(dynamic map)
      : super(
            namespace: map['namespace'],
            networkConfig: NetworkConfigurationReader(map['networkConfig']),
            trackerConfig:
                TrackerConfigurationReader(map['trackerConfig'] ?? {}),
            subjectConfig: map['subjectConfig'] != null
                ? SubjectConfigurationReader(map['subjectConfig'])
                : null,
            gdprConfig: map['gdprConfig'] != null
                ? GdprConfigurationReader(map['gdprConfig'])
                : null,
            emitterConfig: map['emitterConfig'] != null
                ? EmitterConfigurationReader(map['emitterConfig'])
                : null);

  dynamic getTrackerOptions() {
    var options = {};

    (networkConfig as NetworkConfigurationReader).addTrackerOptions(options);
    if (trackerConfig != null) {
      (trackerConfig as TrackerConfigurationReader).addTrackerOptions(options);
    }
    if (emitterConfig != null) {
      (emitterConfig as EmitterConfigurationReader).addTrackerOptions(options);
    }

    return options;
  }
}
