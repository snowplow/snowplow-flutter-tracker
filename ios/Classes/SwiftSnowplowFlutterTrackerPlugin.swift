import Flutter
import UIKit

public class SwiftSnowplowFlutterTrackerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "snowplow_flutter_tracker", binaryMessenger: registrar.messenger())
        let instance = SwiftSnowplowFlutterTrackerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "createTracker":
            onCreateTracker(call, result: result)
        case "removeTracker":
            onRemoveTracker(call, result: result)
        case "removeAllTrackers":
            onRemoveAllTrackers(result: result)
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
        case "getIsInBackground":
            onGetIsInBackground(call, result: result)
        case "getBackgroundIndex":
            onGetBackgroundIndex(call, result: result)
        case "getForegroundIndex":
            onGetForegroundIndex(call, result: result)
        case "setUserId":
            onSetUserId(call, result: result)
        case "setNetworkUserId":
            onSetNetworkUserId(call, result: result)
        case "setDomainUserId":
            onSetDomainUserId(call, result: result)
        case "setIpAddress":
            onSetIpAddress(call, result: result)
        case "setUseragent":
            onSetUseragent(call, result: result)
        case "setTimezone":
            onSetTimezone(call, result: result)
        case "setLanguage":
            onSetLanguage(call, result: result)
        case "setScreenResolution":
            onSetScreenResolution(call, result: result)
        case "setScreenViewport":
            onSetScreenViewport(call, result: result)
        case "setColorDepth":
            onSetColorDepth(call, result: result)
        case "getEmittableEvents":
            onGetEmittableEvents(call, result: result)
        case "removeAllEventStoreEvents":
            onRemoveAllEventStoreEvents(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }

    }
    
    private func onCreateTracker(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (CreateTrackerMessageReader, [String: Any]) = decodeCall(call) {
            SnowplowFlutterTrackerController.createTracker(message, arguments: arguments)
        }
        result(nil)
    }
    
    private func onRemoveTracker(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (RemoveTrackerMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.removeTracker(message)
        }
        result(nil)
    }
    
    private func onRemoveAllTrackers(result: @escaping FlutterResult) {
        SnowplowFlutterTrackerController.removeAllTrackers()
        result(nil)
    }

    private func onTrackStructured(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackStructuredMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.trackStructured(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackSelfDescribing(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackSelfDescribingMesssageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.trackSelfDescribing(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackScreenView(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackScreenViewMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.trackScreenView(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackTiming(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackTimingMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.trackTiming(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackConsentGranted(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackConsentGrantedMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.trackConsentGranted(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onTrackConsentWithdrawn(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, arguments): (TrackConsentWithdrawnMessageReader, [String: Any]) = decodeCall(call),
           let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.trackConsentWithdrawn(message, eventMessage: eventMessage, arguments: arguments)
        }
        result(nil)
    }
    
    private func onGetSessionUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowFlutterTrackerController.sessionUserId(message))
        } else {
            result(nil)
        }
    }
    
    private func onGetSessionId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowFlutterTrackerController.sessionId(message))
        } else {
            result(nil)
        }
    }
    
    private func onGetSessionIndex(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowFlutterTrackerController.sessionIndex(message))
        } else {
            result(nil)
        }
    }
    
    private func onGetIsInBackground(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowFlutterTrackerController.isInBackground(message))
        } else {
            result(nil)
        }
    }
    
    private func onGetBackgroundIndex(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowFlutterTrackerController.backgroundIndex(message))
        } else {
            result(nil)
        }
    }
    
    private func onGetForegroundIndex(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (GetParameterMessageReader, Any) = decodeCall(call) {
            result(SnowplowFlutterTrackerController.foregroundIndex(message))
        } else {
            result(nil)
        }
    }
    
    private func onSetUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetUserIdMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setUserId(message)
        }
        result(nil)
    }
    
    private func onSetNetworkUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetNetworkUserIdMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setNetworkUserId(message)
        }
        result(nil)
    }
    
    private func onSetDomainUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetDomainUserIdMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setDomainUserId(message)
        }
        result(nil)
    }
    
    private func onSetIpAddress(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetIpAddressMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setIpAddress(message)
        }
        result(nil)
    }
    
    private func onSetUseragent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetUseragentMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setUseragent(message)
        }
        result(nil)
    }
    
    private func onSetTimezone(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetTimezoneMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setTimezone(message)
        }
        result(nil)
    }
    
    private func onSetLanguage(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetLanguageMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setLanguage(message)
        }
        result(nil)
    }
    
    private func onSetScreenResolution(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetScreenResolutionMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setScreenResolution(message)
        }
        result(nil)
    }
    
    private func onSetScreenViewport(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetScreenViewportMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setScreenViewport(message)
        }
        result(nil)
    }
    
    private func onSetColorDepth(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetColorDepthMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setColorDepth(message)
        }
        result(nil)
    }
    
    private func onGetEmittableEvents(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        if let (message, _): (GetEmittableEventsMessageReader, Any) = decodeCall(call) {
//            SnowplowFlutterTrackerController.getEmittableEvents(message)
//        }
        result(nil)
    }

    private func onRemoveAllEventStoreEvents(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        if let (message, _): (RemoveAllEventStoreEventsMessageReader, Any) = decodeCall(call) {
//            SnowplowFlutterTrackerController.removeAllEventStoreEvents(message)
//        }
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
