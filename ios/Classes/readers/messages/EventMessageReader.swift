//
//  EventMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct EventMessageReader: Decodable {
    let tracker: String
    let contexts: [SelfDescribingJsonReader]?
}

extension EventMessageReader {
    func addContextsToEvent(_ event: Event, arguments: [String: Any]) {
        if let readers = self.contexts,
           let readersArgs = arguments["contexts"] as? [[String: Any]] {
            let contexts = zip(readers, readersArgs).map { (reader, readerArgs) in
                reader.toSelfDescribingJson(arguments: readerArgs)
            }.compactMap { $0 }
            event.contexts(NSMutableArray(array: contexts))
        }
    }
}
