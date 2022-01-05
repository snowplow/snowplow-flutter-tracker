//
//  TrackConsentGrantedMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct TrackConsentGrantedMessageReader: Decodable {
    let eventData: ConsentGrantedReader
}

extension TrackConsentGrantedMessageReader {
    func toConsentGranted() -> ConsentGranted {
        return eventData.toConsentGranted()
    }
}
