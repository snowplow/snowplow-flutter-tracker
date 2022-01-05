//
//  SetColorDepthMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation

struct SetColorDepthMessageReader: Decodable {
    let tracker: String
    let colorDepth: Int?
    
    var colorDepthNumber: NSNumber? {
        if let depth = self.colorDepth { return NSNumber(value: depth) }
        return nil
    }
}
