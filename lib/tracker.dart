import 'dart:async';

import 'package:snowplow_flutter_tracker/events.dart';
import 'package:snowplow_flutter_tracker/snowplow.dart';
import 'package:snowplow_flutter_tracker/helpers.dart';

class Tracker {
  final String namespace;

  const Tracker({required this.namespace});

  Future<void> removeTracker() async {
    await Snowplow.removeTracker(namespace);
  }

  Future<void> track(Event event, {List<SelfDescribing>? contexts}) async {
    await Snowplow.track(event, tracker: namespace, contexts: contexts);
  }

  Future<void> setUserId(String? userId) async {
    await Snowplow.setUserId(userId, tracker: namespace);
  }

  Future<void> setNetworkUserId(String? networkUserId) async {
    await Snowplow.setNetworkUserId(networkUserId, tracker: namespace);
  }

  Future<void> setDomainUserId(String? domainUserId) async {
    await Snowplow.setDomainUserId(domainUserId, tracker: namespace);
  }

  Future<void> setIpAddress(String? ipAddress) async {
    await Snowplow.setIpAddress(ipAddress, tracker: namespace);
  }

  Future<void> setUseragent(String? useragent) async {
    await Snowplow.setUseragent(useragent, tracker: namespace);
  }

  Future<void> setTimezone(String? timezone) async {
    await Snowplow.setTimezone(timezone, tracker: namespace);
  }

  Future<void> setLanguage(String? language) async {
    await Snowplow.setLanguage(language, tracker: namespace);
  }

  Future<void> setScreenResolution(Size? resolution) async {
    await Snowplow.setScreenResolution(resolution, tracker: namespace);
  }

  Future<void> setScreenViewport(Size? viewport) async {
    await Snowplow.setScreenViewport(viewport, tracker: namespace);
  }

  Future<void> setColorDepth(int? colorDepth) async {
    await Snowplow.setColorDepth(colorDepth, tracker: namespace);
  }

  Future<String?> get sessionUserId async {
    return await Snowplow.getSessionUserId(tracker: namespace);
  }

  Future<String?> get sessionId async {
    return await Snowplow.getSessionId(tracker: namespace);
  }

  Future<int?> get sessionIndex async {
    return await Snowplow.getSessionIndex(tracker: namespace);
  }

  Future<bool?> get isInBackground async {
    return await Snowplow.getIsInBackground(tracker: namespace);
  }

  Future<int?> get backgroundIndex async {
    return await Snowplow.getBackgroundIndex(tracker: namespace);
  }

  Future<int?> get foregroundIndex async {
    return await Snowplow.getForegroundIndex(tracker: namespace);
  }
}
