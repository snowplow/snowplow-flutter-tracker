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

struct MediaTrackingConfigurationReader: Decodable {
    let id: String
    let boundaries: [Int]?
    let contexts: [SelfDescribingJsonReader]?
    let player: MediaPlayerEntityReader?
    let pings: Bool
    let pingInterval: Int?
    let maxPausedPings: Int?
    let session: Bool
}

extension MediaTrackingConfigurationReader {
    func toMediaTrackingConfiguration(arguments: [String: Any]) -> MediaTrackingConfiguration {
        let configuration = MediaTrackingConfiguration(
            id: self.id,
            pings: self.pings,
            player: self.player?.toMediaPlayerEntity(),
            session: self.session
        )
        
        if let boundaries = self.boundaries { configuration.boundaries = boundaries }
        
        if let readers = self.contexts,
           let readersArgs = arguments["contexts"] as? [[String: Any]] {
            let entities = zip(readers, readersArgs).map { (reader, readerArgs) in
                reader.toSelfDescribingJson(arguments: readerArgs)
            }.compactMap { $0 }
            configuration.entities = entities
        }
        
        if let pingInterval = self.pingInterval { configuration.pingInterval = pingInterval }
        if let maxPausedPings = self.maxPausedPings { configuration.maxPausedPings = maxPausedPings }
        
        return configuration
    }
}
