import Flutter
import UIKit

public class SwiftSnowplowFlutterTrackerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "snowplow_flutter_tracker", binaryMessenger: registrar.messenger())
    let instance = SwiftSnowplowFlutterTrackerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
