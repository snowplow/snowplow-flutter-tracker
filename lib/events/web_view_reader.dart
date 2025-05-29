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

import 'package:snowplow_tracker/snowplow_tracker.dart';

/// Event to track a user withdrawing consent for data collection.
///
/// A consent document context will be attached to the event using the id and version arguments supplied.
/// To specify that a user opts out of all data collection, [all] should be set to true.
/// {@category Tracking events}
/// {@category Adding data to your events}
@immutable
class WebViewReader implements Event {
  final SelfDescribing? selfDescribingEventData;
  final String? eventName;
  final String? trackerVersion;
  final String? useragent;
  final String? pageUrl;
  final String? pageTitle;
  final String? referrer;
  final String? category;
  final String? action;
  final String? label;
  final String? property;
  final double? value;
  final int? pingXOffsetMin;
  final int? pingXOffsetMax;
  final int? pingYOffsetMin;
  final int? pingYOffsetMax;

  const WebViewReader(
      {this.selfDescribingEventData,
      this.eventName,
      this.trackerVersion,
      this.useragent,
      this.pageUrl,
      this.pageTitle,
      this.referrer,
      this.category,
      this.action,
      this.label,
      this.property,
      this.value,
      this.pingXOffsetMin,
      this.pingXOffsetMax,
      this.pingYOffsetMin,
      this.pingYOffsetMax});

  WebViewReader.fromMap(Map<String, Object?> map)
      : selfDescribingEventData = map['selfDescribingEventData'] != null
            ? SelfDescribing.fromMap(
                map['selfDescribingEventData'] as Map<String, Object?>)
            : null,
        eventName = map['eventName'] as String?,
        trackerVersion = map['trackerVersion'] as String?,
        useragent = map['useragent'] as String?,
        pageUrl = map['pageUrl'] as String?,
        pageTitle = map['pageTitle'] as String?,
        referrer = map['referrer'] as String?,
        category = map['category'] as String?,
        action = map['action'] as String?,
        label = map['label'] as String?,
        property = map['property'] as String?,
        value = (map['value'] as num?)?.toDouble(),
        pingXOffsetMin = map['pingXOffsetMin'] as int?,
        pingXOffsetMax = map['pingXOffsetMax'] as int?,
        pingYOffsetMin = map['pingYOffsetMin'] as int?,
        pingYOffsetMax = map['pingYOffsetMax'] as int?;

  @override
  String endpoint() {
    return 'trackWebViewReader';
  }

  @override
  Map<String, Object?> toMap() {
    final data = <String, Object?>{
      'selfDescribingEventData': selfDescribingEventData?.toMap(),
      'eventName': eventName,
      'trackerVersion': trackerVersion,
      'useragent': useragent,
      'pageUrl': pageUrl,
      'pageTitle': pageTitle,
      'referrer': referrer,
      'category': category,
      'action': action,
      'label': label,
      'property': property,
      'value': value,
      'pingXOffsetMin': pingXOffsetMin,
      'pingXOffsetMax': pingXOffsetMax,
      'pingYOffsetMin': pingYOffsetMin,
      'pingYOffsetMax': pingYOffsetMax,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
