//
//  TrackSelfDescribingMesssageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct TrackSelfDescribingMesssageReader: Decodable {
    let eventData: SelfDescribingJsonReader
}

extension TrackSelfDescribingMesssageReader {
    func toSelfDescribing(arguments: [String: Any]) -> SelfDescribing? {
        if let eventArgs = arguments["eventData"] as? [String: Any] {
            return eventData.toSelfDescribing(arguments: eventArgs)
        }
        return nil
    }
}
