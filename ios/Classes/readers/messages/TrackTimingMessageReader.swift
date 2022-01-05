//
//  TrackTimingMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct TrackTimingMessageReader: Decodable {
    let eventData: TimingReader
}

extension TrackTimingMessageReader {
    func toTiming() -> Timing {
        return eventData.toTiming()
    }
}
