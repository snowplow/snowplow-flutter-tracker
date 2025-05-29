import 'dart:convert';

import 'package:snowplow_tracker/events/web_view_reader.dart';
import 'package:snowplow_tracker/snowplow_tracker.dart';

typedef JavaScriptMessageHandler = void Function(String message);

/// Represents a parsed WebView message and its possible event types.
/// Only one event type will be set based on the command.
class MessageEvent {
  final WebViewReader? webViewReader;
  final SelfDescribing? selfDescribing;
  final Structured? structured;
  final ScreenView? screenView;
  final PageViewEvent? pageViewEvent;

  const MessageEvent({
    this.webViewReader,
    this.selfDescribing,
    this.structured,
    this.screenView,
    this.pageViewEvent,
  });

  MessageEvent.fromMap(String command, Map<String, dynamic> json)
      : webViewReader =
            command == 'trackWebViewEvent' ? WebViewReader.fromMap(json) : null,
        selfDescribing = command == 'trackSelfDescribingEvent'
            ? SelfDescribing.fromMap(json)
            : null,
        structured =
            command == 'trackStructEvent' ? Structured.fromMap(json) : null,
        screenView =
            command == 'trackScreenView' ? ScreenView.fromMap(json) : null,
        pageViewEvent =
            command == 'trackPageView' ? PageViewEvent.fromMap(json) : null;

  /// Returns the actual Snowplow event instance based on the initialized field.
  /// Throws an exception if no valid event is found.
  Event toEvent() {
    if (webViewReader != null) {
      return webViewReader!;
    } else if (selfDescribing != null) {
      return selfDescribing!;
    } else if (structured != null) {
      return structured!;
    } else if (screenView != null) {
      return screenView!;
    } else if (pageViewEvent != null) {
      return pageViewEvent!;
    }
    throw Exception("No valid event found in MessageEvent");
  }
}

/// Represents a message received from the WebView, parsed into structured data.
/// Contains the command, the event, any associated contexts, and optional tracker namespaces.
class Message {
  final String command;

  final MessageEvent event;
  final List<SelfDescribing>? contexts;
  final List<String>? trackers;

  Message(
      {required this.command,
      required this.event,
      this.contexts,
      this.trackers});

  Message.fromMap(Map<String, dynamic> data)
      : event = MessageEvent.fromMap(data["command"], data["event"]),
        command = data["command"] as String,
        contexts = (data["context"] as List<dynamic>?)
            ?.map((e) => SelfDescribing.fromMap(e as Map<String, Object?>))
            .toList(),
        trackers = (data["trackers"] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList();

  Message.fromJson(String json)
      : this.fromMap(jsonDecode(json) as Map<String, dynamic>);

  /// Tracks the event using the provided tracker.
  /// Respects the `ignoreTrackerNamespace` flag or matches against provided namespaces.
  void trackEvent(SnowplowTracker tracker, bool ignoreTrackerNamespace) {
    if (ignoreTrackerNamespace ||
        (trackers ?? []).isEmpty ||
        trackers!.contains(tracker.namespace)) {
      tracker.track(event.toEvent(), contexts: contexts);
    }
  }
}

/// A utility class to integrate Snowplow tracking with a WebView.
/// Parses incoming messages and tracks the events using a given tracker.
class WebViewIntegration {
  /// The name of the JavaScript channel expected from the WebView.
  final String channelName = 'ReactNativeWebView';
  final SnowplowTracker tracker;
  final bool ignoreTrackerNamespace;

  WebViewIntegration(
      {required this.tracker, this.ignoreTrackerNamespace = true});

  /// Parses and handles an incoming message from the WebView, tracking the corresponding event.
  void handleMessage(String msg) {
    if (msg.isNotEmpty) {
      Message message = Message.fromJson(msg);
      message.trackEvent(tracker, ignoreTrackerNamespace);
    }
  }

  /// Registers the JavaScript channel with the WebView controller to receive tracking messages.
  void registerJavaScriptChannel(dynamic webViewController) {
    webViewController.addJavaScriptChannel(
      channelName,
      onMessageReceived: (message) {
        handleMessage(message.message);
      },
    );
  }
}
