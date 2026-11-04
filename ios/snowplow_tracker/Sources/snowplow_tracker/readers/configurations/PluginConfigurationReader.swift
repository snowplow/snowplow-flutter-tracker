// Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
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

struct PluginConfigurationReader: Decodable {
    let identifier: String
    let afterTrack: Bool?
}

extension PluginConfigurationReader {
    func toConfiguration(afterTrackCallback: @escaping (String, InspectableEvent) -> Void,
                         entities: [SelfDescribingJson]?) -> PluginConfiguration {
        let plugin = PluginConfiguration(identifier: identifier)
        if afterTrack == true {
            let identifier = self.identifier
            _ = plugin.afterTrack { event in afterTrackCallback(identifier, event) }
        }
        if let entities = entities {
            _ = plugin.entities { _ in entities }
        }
        return plugin
    }

    /// Reads the entities from the plugin arguments, as `Decodable` can't decode their data
    static func entities(arguments: [String: Any]) -> [SelfDescribingJson]? {
        guard let entitiesArgs = arguments["entities"] as? [[String: Any]] else {
            return nil
        }
        return entitiesArgs.compactMap { entityArgs in
            let entity = (entityArgs["schema"] as? String).flatMap { schema in
                SelfDescribingJsonReader(schema: schema).toSelfDescribingJson(arguments: entityArgs)
            }
            if entity == nil {
                NSLog("SnowplowTracker: skipping plugin entity without a schema or data map: %@", "\(entityArgs)")
            }
            return entity
        }
    }
}
