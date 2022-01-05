//
//  TrackConsentWithdrawnMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct TrackConsentWithdrawnMessageReader: Decodable {
    let eventData: ConsentWithdrawnReader
}

extension TrackConsentWithdrawnMessageReader {
    func toConsentWithdrawn() -> ConsentWithdrawn {
        return eventData.toConsentWithdrawn()
    }
}
