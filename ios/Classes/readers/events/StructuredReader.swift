//
//  StructuredReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct StructuredReader: Decodable {
    let category: String
    let action: String
    let label: String?
    let property: String?
    let value: Double?
}

extension StructuredReader {
    func toStructured() -> Structured {
        let event = Structured(category: category, action: action)
        if let label = self.label { event.label(label) }
        if let prop = self.property { event.property(prop) }
        if let value = self.value { event.value(NSNumber(value: value)) }
        return event
    }
}
