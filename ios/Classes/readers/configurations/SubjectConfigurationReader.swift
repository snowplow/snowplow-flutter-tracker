//
//  SubjectConfigurationReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 03/01/2022.
//

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
