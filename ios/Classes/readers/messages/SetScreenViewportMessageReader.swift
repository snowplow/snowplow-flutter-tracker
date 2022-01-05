//
//  SetScreenViewportMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct SetScreenViewportMessageReader: Decodable {
    let tracker: String
    let screenViewport: [Double]?

    var screenViewportSize: SPSize? {
        if let screenResolution = self.screenViewport,
           let width = screenResolution.first,
           let height = screenResolution.last {
            return SPSize(width: Int(width), height: Int(height))
        }
        return nil
    }
}
