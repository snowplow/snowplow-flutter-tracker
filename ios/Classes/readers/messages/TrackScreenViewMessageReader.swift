//
//  TrackScreenViewMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct TrackScreenViewMessageReader: Decodable {
    let eventData: ScreenViewReader
}

extension TrackScreenViewMessageReader {
    func toScreenView() -> ScreenView {
        return eventData.toScreenView()
    }
}
