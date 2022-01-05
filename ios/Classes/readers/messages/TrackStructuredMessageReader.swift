//
//  TrackStructuredMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct TrackStructuredMessageReader: Decodable {
    let eventData: StructuredReader
}

extension TrackStructuredMessageReader {
    func toStructured() -> Structured {
        return eventData.toStructured()
    }
}
