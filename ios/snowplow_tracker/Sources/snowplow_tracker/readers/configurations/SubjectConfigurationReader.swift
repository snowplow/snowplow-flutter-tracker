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

import Foundation
import SnowplowTracker
import CoreImage

struct SubjectConfigurationReader: Decodable {
    let userId: String?
    let networkUserId: String?
    let domainUserId: String?
    let userAgent: String?
    let ipAddress: String?
    let timezone: String?
    let language: String?
    let screenResolution: [Double]?
    let screenViewport: [Double]?
    let colorDepth: Double?

    var screenResolutionSize: SPSize? {
        if let screenResolution = self.screenResolution,
           let width = screenResolution.first,
           let height = screenResolution.last {
            return SPSize(width: Int(width), height: Int(height))
        }
        return nil
    }
    var screenViewportSize: SPSize? {
        if let screenViewport = self.screenViewport,
           let width = screenViewport.first,
           let height = screenViewport.last {
            return SPSize(width: Int(width), height: Int(height))
        }
        return nil
    }
}

extension SubjectConfigurationReader {
    func toConfiguration() -> SubjectConfiguration {
        let configuration = SubjectConfiguration()
        
        if let uid = self.userId { configuration.userId(uid) }
        if let nid = self.networkUserId { configuration.networkUserId(nid) }
        if let did = self.domainUserId { configuration.domainUserId(did) }
        if let ua = self.userAgent { configuration.useragent(ua) }
        if let ip = self.ipAddress { configuration.ipAddress(ip) }
        if let tz = self.timezone { configuration.timezone(tz) }
        if let lang = self.language { configuration.language(lang) }
        if let sr = self.screenResolutionSize { configuration.screenResolution(sr) }
        if let sv = self.screenViewportSize { configuration.screenViewPort(sv) }
        if let cd = self.colorDepth { configuration.colorDepth(NSNumber(value: Int(cd))) }
        
        return configuration
    }
}
