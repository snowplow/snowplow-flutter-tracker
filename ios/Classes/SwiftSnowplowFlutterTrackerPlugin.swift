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
            SnowplowFlutterTrackerController.createTracker(message, arguments: arguments)
        }
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
    
    private func onSetUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let (message, _): (SetUserIdMessageReader, Any) = decodeCall(call) {
            SnowplowFlutterTrackerController.setUserId(message)
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
