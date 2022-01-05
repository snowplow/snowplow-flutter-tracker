//
//  SelfDescribingJsonReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct SelfDescribingJsonReader: Decodable {
    let schema: String
}

extension SelfDescribingJsonReader {
    func toSelfDescribingJson(arguments: [String: Any]) -> SelfDescribingJson? {
        if let data = arguments["data"] as? [String: Any] {
            return SelfDescribingJson(schema: schema, andDictionary: data)
        }
        return nil
    }
    
    func toSelfDescribing(arguments: [String: Any]) -> SelfDescribing? {
        if let json = toSelfDescribingJson(arguments: arguments) {
            return SelfDescribing(eventData: json)
        }
        return nil
    }
}
