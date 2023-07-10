// Copyright (c) 2022 Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

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
            let entities = zip(readers, readersArgs).map { (reader, readerArgs) in
                reader.toSelfDescribingJson(arguments: readerArgs)
            }.compactMap { $0 }
            event.entities(entities)
        }
    }
}
