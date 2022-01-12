import 'package:flutter/foundation.dart';

@immutable
class TrackerConfiguration {
  final String? appId;
  final String? devicePlatform;
  final bool? base64Encoding;
  final bool? platformContext;
  final bool? geoLocationContext;
  final bool? sessionContext;
  final bool? webPageContext;

  const TrackerConfiguration(
      {this.appId,
      this.devicePlatform,
      this.base64Encoding,
      this.platformContext,
      this.geoLocationContext,
      this.sessionContext,
      this.webPageContext});

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'appId': appId,
      'devicePlatform': devicePlatform,
      'base64Encoding': base64Encoding,
      'platformContext': platformContext,
      'geoLocationContext': geoLocationContext,
      'sessionContext': sessionContext,
      'webPageContext': webPageContext,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
