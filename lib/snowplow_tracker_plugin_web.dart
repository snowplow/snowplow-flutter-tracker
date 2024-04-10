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

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'src/web/readers/events/media_event_reader.dart';
import 'src/web/readers/messages/end_media_tracking_message_reader.dart';
import 'src/web/readers/messages/start_media_tracking_message_reader.dart';
import 'src/web/readers/messages/update_media_tracking_message_reader.dart';
import 'src/web/readers/configurations/configuration_reader.dart';
import 'src/web/readers/messages/event_message_reader.dart';
import 'src/web/readers/messages/set_user_id_message_reader.dart';
import 'src/web/snowplow_tracker_controller.dart';

class SnowplowTrackerPluginWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'snowplow_tracker',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = SnowplowTrackerPluginWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'createTracker':
        return onCreateTracker(call);
      case 'trackStructured':
        return onTrackStructured(call);
      case 'trackSelfDescribing':
        return onTrackSelfDescribing(call);
      case 'trackScreenView':
        return onTrackScreenView(call);
      case 'trackScrollChanged':
        return onTrackScrollChanged(call);
      case 'trackListItemView':
        return onTrackListItemView(call);
      case 'trackTiming':
        return onTrackTiming(call);
      case 'trackConsentGranted':
        return onTrackConsentGranted(call);
      case 'trackConsentWithdrawn':
        return onTrackConsentWithdrawn(call);
      case 'trackPageView':
        return onTrackPageView(call);
      case 'setUserId':
        return onSetUserId(call);
      case "getSessionUserId":
        return onGetSessionUserId(call);
      case "getSessionId":
        return onGetSessionId(call);
      case "getSessionIndex":
        return onGetSessionIndex(call);
      case "startMediaTracking":
        return onStartMediaTracking(call);
      case "endMediaTracking":
        return onEndMediaTracking(call);
      case "updateMediaTracking":
        return onUpdateMediaTracking(call);
      case "trackMediaAdBreakEndEvent":
        return onTrackMediaAdBreakEndEvent(call);
      case "trackMediaAdBreakStartEvent":
        return onTrackMediaAdBreakStartEvent(call);
      case "trackMediaAdClickEvent":
        return onTrackMediaAdClickEvent(call);
      case "trackMediaAdCompleteEvent":
        return onTrackMediaAdCompleteEvent(call);
      case "trackMediaAdFirstQuartileEvent":
        return onTrackMediaAdFirstQuartileEvent(call);
      case "trackMediaAdMidpointEvent":
        return onTrackMediaAdMidpointEvent(call);
      case "trackMediaAdPauseEvent":
        return onTrackMediaAdPauseEvent(call);
      case "trackMediaAdResumeEvent":
        return onTrackMediaAdResumeEvent(call);
      case "trackMediaAdSkipEvent":
        return onTrackMediaAdSkipEvent(call);
      case "trackMediaAdStartEvent":
        return onTrackMediaAdStartEvent(call);
      case "trackMediaAdThirdQuartileEvent":
        return onTrackMediaAdThirdQuartileEvent(call);
      case "trackMediaBufferEndEvent":
        return onTrackMediaBufferEndEvent(call);
      case "trackMediaBufferStartEvent":
        return onTrackMediaBufferStartEvent(call);
      case "trackMediaEndEvent":
        return onTrackMediaEndEvent(call);
      case "trackMediaErrorEvent":
        return onTrackMediaErrorEvent(call);
      case "trackMediaFullscreenChangeEvent":
        return onTrackMediaFullscreenChangeEvent(call);
      case "trackMediaPauseEvent":
        return onTrackMediaPauseEvent(call);
      case "trackMediaPictureInPictureChangeEvent":
        return onTrackMediaPictureInPictureChangeEvent(call);
      case "trackMediaPlayEvent":
        return onTrackMediaPlayEvent(call);
      case "trackMediaPlaybackRateChangeEvent":
        return onTrackMediaPlaybackRateChangeEvent(call);
      case "trackMediaQualityChangeEvent":
        return onTrackMediaQualityChangeEvent(call);
      case "trackMediaReadyEvent":
        return onTrackMediaReadyEvent(call);
      case "trackMediaSeekEndEvent":
        return onTrackMediaSeekEndEvent(call);
      case "trackMediaSeekStartEvent":
        return onTrackMediaSeekStartEvent(call);
      case "trackMediaVolumeChangeEvent":
        return onTrackMediaVolumeChangeEvent(call);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'snowplow_tracker for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  void onCreateTracker(MethodCall call) {
    var configuration = ConfigurationReader(call.arguments);
    SnowplowTrackerController.createTracker(configuration);
  }

  void onTrackStructured(MethodCall call) {
    var message = EventMessageReader.withStructured(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackSelfDescribing(MethodCall call) {
    var message = EventMessageReader.withSelfDescribing(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackScreenView(MethodCall call) {
    var message = EventMessageReader.withScreenView(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackScrollChanged(MethodCall call) {
    var message = EventMessageReader.withScrollChanged(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackListItemView(MethodCall call) {
    var message = EventMessageReader.withListItemView(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackTiming(MethodCall call) {
    var message = EventMessageReader.withTiming(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackConsentGranted(MethodCall call) {
    var message = EventMessageReader.withConsentGranted(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackConsentWithdrawn(MethodCall call) {
    var message = EventMessageReader.withConsentWithdrawn(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onTrackPageView(MethodCall call) {
    var message = EventMessageReader.withPageView(call.arguments);
    SnowplowTrackerController.trackEvent(message);
  }

  void onSetUserId(MethodCall call) {
    var message = SetUserIdMessageReader(call.arguments);
    SnowplowTrackerController.setUserId(message);
  }

  String? onGetSessionUserId(MethodCall call) {
    return SnowplowTrackerController.getSessionUserId();
  }

  String? onGetSessionId(MethodCall call) {
    return SnowplowTrackerController.getSessionId();
  }

  int? onGetSessionIndex(MethodCall call) {
    return SnowplowTrackerController.getSessionIndex();
  }

  void onStartMediaTracking(MethodCall call) {
    var message = StartMediaTrackingMessageReader(call.arguments);
    return SnowplowTrackerController.startMediaTracking(message);
  }

  void onEndMediaTracking(MethodCall call) {
    var message = EndMediaTrackingMessageReader(call.arguments);
    return SnowplowTrackerController.endMediaTracking(message);
  }

  void onUpdateMediaTracking(MethodCall call) {
    var message = UpdateMediaTrackingMessageReader(call.arguments);
    return SnowplowTrackerController.updateMediaTracking(message);
  }

  void onTrackMediaAdBreakEndEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdBreakEnd, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdBreakStartEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdBreakStart, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdClickEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdClick, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdCompleteEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdComplete, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdFirstQuartileEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdFirstQuartile, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdMidpointEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdMidpoint, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdPauseEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdPause, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdResumeEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdResume, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdSkipEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdSkip, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdStartEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdStart, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaAdThirdQuartileEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaAdThirdQuartile, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaBufferEndEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaBufferEnd, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaBufferStartEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaBufferStart, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaEndEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaEnd, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaErrorEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaError, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaFullscreenChangeEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaFullscreenChange, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaPauseEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaPause, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaPictureInPictureChangeEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaPictureInPictureChange, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaPlayEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaPlay, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaPlaybackRateChangeEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaPlaybackRateChange, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaQualityChangeEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaQualityChange, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaReadyEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaReady, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaSeekEndEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaSeekEnd, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaSeekStartEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaSeekStart, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }

  void onTrackMediaVolumeChangeEvent(MethodCall call) {
    var message = EventMessageReader.withMediaEvent(
        MediaEndpoint.trackMediaVolumeChange, call.arguments);
    return SnowplowTrackerController.trackEvent(message);
  }
}
