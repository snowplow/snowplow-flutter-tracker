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
    let base64Encoding: Bool?
    let platformContext: Bool?
    let geoLocationContext: Bool?
    let sessionContext: Bool?
    
    var devicePlatformType: DevicePlatform? {
        if let devicePlatform = self.devicePlatform { return SPStringToDevicePlatform(devicePlatform) }
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
        if let pc = self.platformContext { trackerConfig.platformContext(pc) }
        if let gc = self.geoLocationContext { trackerConfig.geoLocationContext(gc) }
        if let sc = self.sessionContext { trackerConfig.sessionContext(sc) }
        
        trackerConfig.applicationContext(false)
        trackerConfig.screenContext(false)
        trackerConfig.screenViewAutotracking(false)
        trackerConfig.lifecycleAutotracking(false)
        trackerConfig.installAutotracking(false)
        trackerConfig.exceptionAutotracking(false)
        trackerConfig.diagnosticAutotracking(false)
        
        return trackerConfig
    }
}
