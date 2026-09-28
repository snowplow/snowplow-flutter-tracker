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

import 'package:flutter_test/flutter_test.dart';
import 'package:snowplow_tracker/src/web/readers/configurations/session_configuration_reader.dart';

void main() {
  test('maps foregroundTimeout to sessionCookieTimeout', () {
    final reader = SessionConfigurationReader(const {
      'foregroundTimeout': 600,
      'backgroundTimeout': 90,
      'continueSessionOnRestart': true,
    });
    final options = {};

    reader.addTrackerOptions(options);

    expect(options, {'sessionCookieTimeout': 600});
  });

  test('leaves tracker options unchanged without foregroundTimeout', () {
    final reader = SessionConfigurationReader(const {'backgroundTimeout': 90});
    final options = {};

    reader.addTrackerOptions(options);

    expect(options, isEmpty);
  });
}
