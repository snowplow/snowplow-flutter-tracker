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
