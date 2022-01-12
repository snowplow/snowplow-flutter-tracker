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
