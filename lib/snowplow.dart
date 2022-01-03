import 'dart:async';

import 'package:flutter/services.dart';
import 'package:snowplow_flutter_tracker/events.dart';
import 'package:snowplow_flutter_tracker/helpers.dart';
import 'package:snowplow_flutter_tracker/tracker.dart';
import 'package:snowplow_flutter_tracker/configurations.dart';

class Snowplow {
  static const MethodChannel _channel =
      MethodChannel('snowplow_flutter_tracker');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Tracker> createTracker(Configuration configuration) async {
    await _channel.invokeMethod('createTracker', configuration.toMap());
    return Tracker(namespace: configuration.namespace);
  }

  static Future<void> removeTracker(String tracker) async {
    await _channel.invokeMethod('removeTracker', {'tracker': tracker});
  }

  static Future<void> removeAllTrackers() async {
    await _channel.invokeMethod('removeAllTrackers');
  }

  static Future<void> track(Event event,
      {required String tracker, List<SelfDescribing>? contexts}) async {
    var message = {
      'tracker': tracker,
      'eventData': event.toMap(),
      'contexts': contexts?.map((c) => c.toMap()).toList()
    };
    await _channel.invokeMethod(event.endpoint(), message);
  }

  static Future<void> setUserId(String? userId,
      {required String tracker}) async {
    await _channel
        .invokeMethod('setUserId', {'tracker': tracker, 'userId': userId});
  }

  static Future<void> setNetworkUserId(String? networkUserId,
      {required String tracker}) async {
    await _channel.invokeMethod('setNetworkUserId',
        {'tracker': tracker, 'networkUserId': networkUserId});
  }

  static Future<void> setDomainUserId(String? domainUserId,
      {required String tracker}) async {
    await _channel.invokeMethod(
        'setDomainUserId', {'tracker': tracker, 'domainUserId': domainUserId});
  }

  static Future<void> setIpAddress(String? ipAddress,
      {required String tracker}) async {
    await _channel.invokeMethod(
        'setIpAddress', {'tracker': tracker, 'ipAddress': ipAddress});
  }

  static Future<void> setUseragent(String? useragent,
      {required String tracker}) async {
    await _channel.invokeMethod(
        'setUseragent', {'tracker': tracker, 'useragent': useragent});
  }

  static Future<void> setTimezone(String? timezone,
      {required String tracker}) async {
    await _channel.invokeMethod(
        'setTimezone', {'tracker': tracker, 'timezone': timezone});
  }

  static Future<void> setLanguage(String? language,
      {required String tracker}) async {
    await _channel.invokeMethod(
        'setLanguage', {'tracker': tracker, 'language': language});
  }

  static Future<void> setScreenResolution(Size? resolution,
      {required String tracker}) async {
    await _channel.invokeMethod('setScreenResolution',
        {'tracker': tracker, 'screenResolution': resolution?.toList()});
  }

  static Future<void> setScreenViewport(Size? viewport,
      {required String tracker}) async {
    await _channel.invokeMethod('setScreenViewport',
        {'tracker': tracker, 'screenViewport': viewport?.toList()});
  }

  static Future<void> setColorDepth(int? colorDepth,
      {required String tracker}) async {
    await _channel.invokeMethod(
        'setColorDepth', {'tracker': tracker, 'colorDepth': colorDepth});
  }

  static Future<String?> getSessionUserId({required String tracker}) async {
    return await _channel
        .invokeMethod('getSessionUserId', {'tracker': tracker});
  }

  static Future<String?> getSessionId({required String tracker}) async {
    return await _channel.invokeMethod('getSessionId', {'tracker': tracker});
  }

  static Future<int?> getSessionIndex({required String tracker}) async {
    return await _channel.invokeMethod('getSessionIndex', {'tracker': tracker});
  }

  static Future<bool?> getIsInBackground({required String tracker}) async {
    return await _channel
        .invokeMethod('getIsInBackground', {'tracker': tracker});
  }

  static Future<int?> getBackgroundIndex({required String tracker}) async {
    return await _channel
        .invokeMethod('getBackgroundIndex', {'tracker': tracker});
  }

  static Future<int?> getForegroundIndex({required String tracker}) async {
    return await _channel
        .invokeMethod('getForegroundIndex', {'tracker': tracker});
  }
}
