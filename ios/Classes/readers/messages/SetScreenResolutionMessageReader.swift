//
//  SetScreenResolutionMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct SetScreenResolutionMessageReader: Decodable {
    let tracker: String
    let screenResolution: [Double]?

    var screenResolutionSize: SPSize? {
        if let screenResolution = self.screenResolution,
           let width = screenResolution.first,
           let height = screenResolution.last {
            return SPSize(width: Int(width), height: Int(height))
        }
        return nil
    }
}
