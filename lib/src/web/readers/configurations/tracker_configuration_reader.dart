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

import 'package:snowplow_tracker/configurations/tracker_configuration.dart';
import 'package:snowplow_tracker/src/web/readers/configurations/web_activity_tracking_reader.dart';

class TrackerConfigurationReader extends TrackerConfiguration {
  TrackerConfigurationReader(dynamic map)
      : super(
            appId: map['appId'],
            devicePlatform: map['devicePlatform'] == null
                ? null
                : DevicePlatform.values.byName(map['devicePlatform']),
            base64Encoding: map['base64Encoding'],
            platformContext: map['platformContext'],
            geoLocationContext: map['geoLocationContext'],
            sessionContext: map['sessionContext'],
            webPageContext: map['webPageContext'],
            webActivityTracking: map['webActivityTracking'] == null
                ? null
                : WebActivityTrackingReader(map['webActivityTracking']),
            userAnonymisation: map['userAnonymisation']);

  void addTrackerOptions(dynamic options) {
    if (appId != null) {
      options['appId'] = appId;
    }
    if (devicePlatform != null) {
      options['platform'] = devicePlatform?.name;
    }
    if (base64Encoding != null) {
      options['encodeBase64'] = base64Encoding;
    }

    var anonymousTracking = {};
    if ((userAnonymisation == true) && sessionContext != true) {
      options['anonymousTracking'] = userAnonymisation;
    } else if ((userAnonymisation == true) && sessionContext == true) {
      anonymousTracking['withSessionTracking'] = true;
      options['anonymousTracking'] = anonymousTracking;
    }

    var contexts = {};
    if (geoLocationContext != null) {
      contexts['geolocation'] = geoLocationContext;
    }
    if (webPageContext != null) {
      contexts['webPage'] = webPageContext;
    }
    if (sessionContext ?? true) {
      contexts['session'] = true;
    }
    if (contexts.isNotEmpty) {
      options['contexts'] = contexts;
    }
  }
}
