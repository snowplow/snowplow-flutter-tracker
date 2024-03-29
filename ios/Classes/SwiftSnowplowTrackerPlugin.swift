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

import Flutter
import UIKit

public class SwiftSnowplowTrackerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "snowplow_tracker", binaryMessenger: registrar.messenger())
        let instance = SwiftSnowplowTrackerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "createTracker":
            onCreateTracker(call, result: result)
        case "trackStructured":
            onTrackStructured(call, result: result)
        case "trackSelfDescribing":
            onTrackSelfDescribing(call, result: result)
        case "trackScreenView":
            onTrackScreenView(call, result: result)
        case "trackScrollChanged":
            onTrackScrollChanged(call, result: result)
        case "trackListItemView":
            onTrackListItemView(call, result: result)
        case "trackTiming":
            onTrackTiming(call, result: result)
        case "trackConsentGranted":
            onTrackConsentGranted(call, result: result)
        case "trackConsentWithdrawn":
            onTrackConsentWithdrawn(call, result: result)
        case "getSessionUserId":
            onGetSessionUserId(call, result: result)
        case "getSessionId":
            onGetSessionId(call, result: result)
        case "getSessionIndex":
            onGetSessionIndex(call, result: result)
        case "setUserId":
            onSetUserId(call, result: result)
        case "startMediaTracking":
            onStartMediaTracking(call, result: result)
        case "endMediaTracking":
            onEndMediaTracking(call, result: result)
        case "updateMediaTracking":
            onUpdateMediaTracking(call, result: result)
        case "trackMediaAdBreakEndEvent":
            onTrackMediaAdBreakEndEvent(call, result: result)
        case "trackMediaAdBreakStartEvent":
            onTrackMediaAdBreakStartEvent(call, result: result)
        case "trackMediaAdClickEvent":
            onTrackMediaAdClickEvent(call, result: result)
        case "trackMediaAdCompleteEvent":
            onTrackMediaAdCompleteEvent(call, result: result)
        case "trackMediaAdFirstQuartileEvent":
            onTrackMediaAdFirstQuartileEvent(call, result: result)
        case "trackMediaAdMidpointEvent":
            onTrackMediaAdMidpointEvent(call, result: result)
        case "trackMediaAdPauseEvent":
            onTrackMediaAdPauseEvent(call, result: result)
        case "trackMediaAdResumeEvent":
            onTrackMediaAdResumeEvent(call, result: result)
        case "trackMediaAdSkipEvent":
            onTrackMediaAdSkipEvent(call, result: result)
        case "trackMediaAdStartEvent":
            onTrackMediaAdStartEvent(call, result: result)
        case "trackMediaAdThirdQuartileEvent":
            onTrackMediaAdThirdQuartileEvent(call, result: result)
        case "trackMediaBufferEndEvent":
            onTrackMediaBufferEndEvent(call, result: result)
        case "trackMediaBufferStartEvent":
            onTrackMediaBufferStartEvent(call, result: result)
        case "trackMediaEndEvent":
            onTrackMediaEndEvent(call, result: result)
        case "trackMediaErrorEvent":
            onTrackMediaErrorEvent(call, result: result)
        case "trackMediaFullscreenChangeEvent":
            onTrackMediaFullscreenChangeEvent(call, result: result)
        case "trackMediaPauseEvent":
            onTrackMediaPauseEvent(call, result: result)
        case "trackMediaPictureInPictureChangeEvent":
            onTrackMediaPictureInPictureChangeEvent(call, result: result)
        case "trackMediaPlayEvent":
            onTrackMediaPlayEvent(call, result: result)
        case "trackMediaPlaybackRateChangeEvent":
            onTrackMediaPlaybackRateChangeEvent(call, result: result)
        case "trackMediaQualityChangeEvent":
            onTrackMediaQualityChangeEvent(call, result: result)
        case "trackMediaReadyEvent":
            onTrackMediaReadyEvent(call, result: result)
        case "trackMediaSeekEndEvent":
            onTrackMediaSeekEndEvent(call, result: result)
        case "trackMediaSeekStartEvent":
            onTrackMediaSeekStartEvent(call, result: result)
        case "trackMediaVolumeChangeEvent":
            onTrackMediaVolumeChangeEvent(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func onCreateTracker(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (CreateTrackerMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.createTracker(message, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackStructured(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackStructuredMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackStructured(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackSelfDescribing(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackSelfDescribingMesssageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackSelfDescribing(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackScreenView(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackScreenViewMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackScreenView(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackScrollChanged(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackScrollChangedMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackScrollChanged(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackListItemView(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackListItemViewMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackListItemView(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackTiming(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackTimingMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackTiming(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackConsentGranted(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackConsentGrantedMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackConsentGranted(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackConsentWithdrawn(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackConsentWithdrawnMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackConsentWithdrawn(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onGetSessionUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowTrackerController.sessionUserId(message))
        } else {
            result(nil)
        }
    }
    
    private func onGetSessionId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowTrackerController.sessionId(message))
        } else {
            result(nil)
        }
    }
    
    private func onGetSessionIndex(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowTrackerController.sessionIndex(message))
        } else {
            result(nil)
        }
    }
    
    private func onSetUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetUserIdMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.setUserId(message)
        }
        result(nil)
    }

    private func onStartMediaTracking(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (StartMediaTrackingMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.startMediaTracking(message, arguments: arguments)
        }
        result(nil)
    }

    private func onEndMediaTracking(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (EndMediaTrackingMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.endMediaTracking(message)
        }
        result(nil)
    }

    private func onUpdateMediaTracking(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (UpdateMediaTrackingMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.updateMediaTracking(message)
        }
        result(nil)
    }

    private func onTrackMediaAdBreakEndEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdBreakEndEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdBreakStartEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdBreakStartEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdClickEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdClickEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdCompleteEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdCompleteEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdFirstQuartileEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdFirstQuartileEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdMidpointEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdMidpointEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdPauseEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackMediaAdEventMessageReader, [String: Any]) = decodeCall(call),
            let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdPauseEvent(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdResumeEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackMediaAdEventMessageReader, [String: Any]) = decodeCall(call),
            let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdResumeEvent(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdSkipEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackMediaAdEventMessageReader, [String: Any]) = decodeCall(call),
            let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdSkipEvent(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdStartEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdStartEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaAdThirdQuartileEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaAdThirdQuartileEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaBufferEndEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaBufferEndEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaBufferStartEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaBufferStartEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaEndEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaEndEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaErrorEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackMediaErrorEventMessageReader, [String: Any]) = decodeCall(call),
            let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackMediaErrorEvent(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaFullscreenChangeEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackMediaFullscreenChangeEventMessageReader, [String: Any]) = decodeCall(call),
            let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackMediaFullscreenChangeEvent(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaPauseEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaPauseEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaPictureInPictureChangeEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackMediaPictureInPictureChangeEventMessageReader, [String: Any]) = decodeCall(call),
            let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackMediaPictureInPictureChangeEvent(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaPlayEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaPlayEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaPlaybackRateChangeEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // if let (message, arguments): (TrackMediaPlaybackRateChangeEventMessageReader, [String: Any]) = decodeCall(call),
        //     let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
        //     SnowplowTrackerController.trackMediaPlaybackRateChangeEvent(message, eventMessage: eventMessage, arguments: arguments)
        // }
        result(nil)
    }

    private func onTrackMediaQualityChangeEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackMediaQualityChangeEventMessageReader, [String: Any]) = decodeCall(call),
            let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackMediaQualityChangeEvent(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaReadyEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaReadyEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaSeekEndEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaSeekEndEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaSeekStartEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (eventMessage, arguments): (EventMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowTrackerController.trackMediaSeekStartEvent(eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func onTrackMediaVolumeChangeEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackMediaVolumeChangeEventMessageReader, [String: Any]) = decodeCall(call),
            let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowTrackerController.trackMediaVolumeChangeEvent(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }

    private func decodeCall<T: Decodable>(_ call: FlutterMethodCall) -> (T, [String: Any])? {
        let decoder = JSONDecoder()
        let arguments: [String: Any] = call.arguments as? [String: Any] ?? [:]

        do {
            let data = try JSONSerialization.data(withJSONObject: arguments, options: .prettyPrinted)
            let message = try decoder.decode(T.self, from: data)
            return (message, arguments)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
