//
//  TimingReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct TimingReader: Decodable {
    let category: String
    let variable: String
    let timing: Int
    let label: String?
}

extension TimingReader {
    func toTiming() -> Timing {
        let event = Timing(category: category, variable: variable, timing: NSNumber(value: timing))
        if let label = self.label { event.label(label) }
        return event
    }
}
