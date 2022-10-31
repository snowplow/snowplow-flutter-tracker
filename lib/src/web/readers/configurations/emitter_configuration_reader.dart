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

import 'package:snowplow_tracker/configurations/emitter_configuration.dart';

class EmitterConfigurationReader extends EmitterConfiguration {
  EmitterConfigurationReader(dynamic map)
      : super(serverAnonymisation: map['serverAnonymisation']);

  void addTrackerOptions(dynamic options) {
    var anonymousTracking = options.containsKey('anonymousTracking')
        ? (options['anonymousTracking'] is bool)
            ? {}
            : options['anonymousTracking']
        : {};

    if (serverAnonymisation == true) {
      anonymousTracking['withServerAnonymisation'] = serverAnonymisation;
    }
    if (anonymousTracking.isNotEmpty) {
      options['anonymousTracking'] = anonymousTracking;
    }
  }
}
