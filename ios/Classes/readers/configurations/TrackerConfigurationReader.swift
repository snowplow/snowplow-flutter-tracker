//
//  TrackerConfigurationReader.swift
//  FMDB
//
//  Created by Matus Tomlein on 03/01/2022.
//

import Foundation
import SnowplowTracker

struct TrackerConfigurationReader: Decodable {
    let appId: String?
    let devicePlatform: String?
    let logLevel: String?
    let base64Encoding: Bool?
    let applicationContext: Bool?
    let platformContext: Bool?
    let geoLocationContext: Bool?
    let sessionContext: Bool?
    let screenContext: Bool?
    let screenViewAutotracking: Bool?
    let lifecycleAutotracking: Bool?
    let installAutotracking: Bool?
    let exceptionAutotracking: Bool?
    let diagnosticAutotracking: Bool?
    
    var devicePlatformType: DevicePlatform? {
        if let devicePlatform = self.devicePlatform { return SPStringToDevicePlatform(devicePlatform) }
        return nil
    }
    var logLevelType: LogLevel? {
        if let logLevel = self.logLevel {
            switch (logLevel) {
            case "error":
                return .error
            case "debug":
                return .debug
            case "verbose":
                return .verbose
            default:
                return .off
            }
        }
        return nil
    }
}

extension TrackerConfigurationReader {
    func toConfiguration() -> TrackerConfiguration {
        let trackerConfig = TrackerConfiguration()
        trackerConfig.trackerVersionSuffix(TrackerVersion.TRACKER_VERSION)
        
        if let appId = self.appId { trackerConfig.appId(appId) }
        if let dp = self.devicePlatformType { trackerConfig.devicePlatform(dp) }
        if let enc = self.base64Encoding { trackerConfig.base64Encoding(enc) }
        if let ll = self.logLevelType { trackerConfig.logLevel(ll) }
        if let ac = self.applicationContext { trackerConfig.applicationContext(ac) }
        if let pc = self.platformContext { trackerConfig.platformContext(pc) }
        if let gc = self.geoLocationContext { trackerConfig.geoLocationContext(gc) }
        if let sc = self.sessionContext { trackerConfig.sessionContext(sc) }
        if let sc = self.screenContext { trackerConfig.screenContext(sc) }
        if let sva = self.screenViewAutotracking { trackerConfig.screenViewAutotracking(sva) }
        if let lca = self.lifecycleAutotracking { trackerConfig.lifecycleAutotracking(lca) }
        if let ia = self.installAutotracking { trackerConfig.installAutotracking(ia) }
        if let ea = self.exceptionAutotracking { trackerConfig.exceptionAutotracking(ea) }
        if let da = self.diagnosticAutotracking { trackerConfig.diagnosticAutotracking(da) }
        
        return trackerConfig
    }
}
