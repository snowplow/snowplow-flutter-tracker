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

import Foundation
import SnowplowTracker

struct TrackerConfigurationReader: Decodable {
    let appId: String?
    let devicePlatform: String?
    let base64Encoding: Bool?
    let platformContext: Bool?
    let geoLocationContext: Bool?
    let sessionContext: Bool?
    let userAnonymisation: Bool?
    let screenContext: Bool?
    let applicationContext: Bool?
    
    var devicePlatformType: DevicePlatform? {
        if let devicePlatform = self.devicePlatform {
            switch devicePlatform {
            case "web":
                return DevicePlatform.web
            case "srv":
                return DevicePlatform.serverSideApp
            case "pc":
                return DevicePlatform.desktop
            case "app":
                return DevicePlatform.general
            case "tv":
                return DevicePlatform.connectedTV
            case "cnsl":
                return DevicePlatform.gameConsole
            case "iot":
                return DevicePlatform.internetOfThings
            default:
                return DevicePlatform.mobile
            }
        }
        return nil
    }
}

extension TrackerConfigurationReader {
    static func defaultConfiguration() -> TrackerConfiguration {
        let trackerConfig = TrackerConfiguration()
        trackerConfig.trackerVersionSuffix(TrackerVersion.TRACKER_VERSION)

        trackerConfig.screenViewAutotracking(false)
        trackerConfig.lifecycleAutotracking(false)
        trackerConfig.installAutotracking(false)
        trackerConfig.exceptionAutotracking(false)
        trackerConfig.diagnosticAutotracking(false)
        trackerConfig.userAnonymisation(false)
        
        return trackerConfig
    }

    func toConfiguration() -> TrackerConfiguration {
        let trackerConfig = TrackerConfigurationReader.defaultConfiguration()
        
        if let appId = self.appId { trackerConfig.appId(appId) }
        if let dp = self.devicePlatformType { trackerConfig.devicePlatform(dp) }
        if let enc = self.base64Encoding { trackerConfig.base64Encoding(enc) }
        if let pc = self.platformContext { trackerConfig.platformContext(pc) }
        if let gc = self.geoLocationContext { trackerConfig.geoLocationContext(gc) }
        if let sc = self.sessionContext { trackerConfig.sessionContext(sc) }
        if let ua = self.userAnonymisation { trackerConfig.userAnonymisation(ua) }
        if let scr = self.screenContext { trackerConfig.screenContext(scr) }
        if let ac = self.applicationContext { trackerConfig.applicationContext(ac) }

        return trackerConfig
    }
}
