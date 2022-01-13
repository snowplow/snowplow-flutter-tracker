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

@immutable
class SubjectConfiguration {
  final String? userId;
  final String? networkUserId;
  final String? domainUserId;
  final String? userAgent;
  final String? ipAddress;
  final String? timezone;
  final String? language;
  final Size? screenResolution;
  final Size? screenViewport;
  final double? colorDepth;

  const SubjectConfiguration(
      {this.userId,
      this.networkUserId,
      this.domainUserId,
      this.userAgent,
      this.ipAddress,
      this.timezone,
      this.language,
      this.screenResolution,
      this.screenViewport,
      this.colorDepth});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'userId': userId,
      'networkUserId': networkUserId,
      'domainUserId': domainUserId,
      'userAgent': userAgent,
      'ipAddress': ipAddress,
      'timezone': timezone,
      'language': language,
      'screenResolution': screenResolution?.toList(),
      'screenViewport': screenViewport?.toList(),
      'colorDepth': colorDepth
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}

@immutable
class Size {
  final double width;
  final double height;

  const Size({required this.width, required this.height});

  List<double> toList() {
    return [width, height];
  }
}
