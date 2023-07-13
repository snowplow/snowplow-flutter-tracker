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

import 'package:snowplow_tracker/configurations/network_configuration.dart';

class NetworkConfigurationReader extends NetworkConfiguration {
  NetworkConfigurationReader(dynamic map)
      : super(
            endpoint: map['endpoint'],
            method: map['method'] == null
                ? null
                : Method.values.byName(map['method']),
            customPostPath: map['customPostPath'],
            requestHeaders: map['requestHeaders'] == null
                ? null
                : (map['requestHeaders'] as Map<Object?, Object?>).cast());

  void addTrackerOptions(dynamic options) {
    if (method != null) {
      options['eventMethod'] = method?.name;
    }
    if (customPostPath != null) {
      options['postPath'] = '/$customPostPath';
    }
    if (requestHeaders != null) {
      options['customHeaders'] = requestHeaders;
    }
  }
}
