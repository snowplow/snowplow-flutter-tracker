import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'readers/configurations/configuration_reader.dart';
import 'readers/messages/event_message_reader.dart';
import 'readers/messages/set_user_id_message_reader.dart';
import 'snowplow_flutter_tracker_controller.dart';

/// A web implementation of the SnowplowFlutterTracker plugin.
class SnowplowFlutterTrackerPlugin {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'snowplow_flutter_tracker',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = SnowplowFlutterTrackerPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);

    // Add JS dynamically if not already imported (this is needed to prevent hot reload or refresh to import it again and again)
    var foundSpJs = false;
    for (html.ScriptElement script
        in html.document.head!.querySelectorAll('script')) {
      if (script.src.contains('snowplow_flutter_tracker/assets/sp.js')) {
        foundSpJs = true;
      }
    }

    if (!foundSpJs) {
      print(
          "WARNING: Importing 'sp.js' from assets, consider importing it directly from your index.html");
      html.document.body!.append(html.ScriptElement()
        ..innerHtml =
            ' ;(function(p,l,o,w,i,n,g){if(!p[i]){p.GlobalSnowplowNamespace=p.GlobalSnowplowNamespace||[]; p.GlobalSnowplowNamespace.push(i);p[i]=function(){(p[i].q=p[i].q||[]).push(arguments) };p[i].q=p[i].q||[];n=l.createElement(o);g=l.getElementsByTagName(o)[0];n.async=1; n.src=w;g.parentNode.insertBefore(n,g)}}(window,document,"script","assets/packages/snowplow_flutter_tracker/assets/sp.js","snowplow")); '
        ..type = 'application/javascript');
    }
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
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
      case 'trackTiming':
        return onTrackTiming(call);
      case 'trackConsentGranted':
        return onTrackConsentGranted(call);
      case 'trackConsentWithdrawn':
        return onTrackConsentWithdrawn(call);
      case 'setUserId':
        return onSetUserId(call);
      case "getSessionUserId":
        return onGetSessionUserId(call);
      case "getSessionId":
        return onGetSessionId(call);
      case "getSessionIndex":
        return onGetSessionIndex(call);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'snowplow_flutter_tracker for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  void onCreateTracker(MethodCall call) {
    var configuration = ConfigurationReader(call.arguments);
    SnowplowFlutterTrackerController.createTracker(configuration);
  }

  void onTrackStructured(MethodCall call) {
    var message = EventMessageReader.withStructured(call.arguments);
    SnowplowFlutterTrackerController.trackEvent(message);
  }

  void onTrackSelfDescribing(MethodCall call) {
    var message = EventMessageReader.withSelfDescribing(call.arguments);
    SnowplowFlutterTrackerController.trackEvent(message);
  }

  void onTrackScreenView(MethodCall call) {
    var message = EventMessageReader.withScreenView(call.arguments);
    SnowplowFlutterTrackerController.trackEvent(message);
  }

  void onTrackTiming(MethodCall call) {
    var message = EventMessageReader.withTiming(call.arguments);
    SnowplowFlutterTrackerController.trackEvent(message);
  }

  void onTrackConsentGranted(MethodCall call) {
    var message = EventMessageReader.withConsentGranted(call.arguments);
    SnowplowFlutterTrackerController.trackEvent(message);
  }

  void onTrackConsentWithdrawn(MethodCall call) {
    var message = EventMessageReader.withConsentWithdrawn(call.arguments);
    SnowplowFlutterTrackerController.trackEvent(message);
  }

  void onSetUserId(MethodCall call) {
    var message = SetUserIdMessageReader(call.arguments);
    SnowplowFlutterTrackerController.setUserId(message);
  }

  String? onGetSessionUserId(MethodCall call) {
    return SnowplowFlutterTrackerController.getSessionUserId();
  }

  String? onGetSessionId(MethodCall call) {
    return SnowplowFlutterTrackerController.getSessionId();
  }

  int? onGetSessionIndex(MethodCall call) {
    return SnowplowFlutterTrackerController.getSessionIndex();
  }
}
