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

struct MediaAdBreakEntityReader: Decodable {
    let name: String?
    let breakId: String
    let breakType: String?
    let podSize: Int?
    
    var breakTypeEnum: MediaAdBreakType? {
        if let breakType = self.breakType {
            switch breakType {
            case "linear":
                return MediaAdBreakType.linear
            case "nonLinear":
                return MediaAdBreakType.nonLinear
            case "companion":
                return MediaAdBreakType.companion
            default:
                return nil
            }
        }
        return nil
    }
}

extension MediaAdBreakEntityReader {
    func toMediaAdBreakEntity() -> MediaAdBreakEntity {
        let entity = MediaAdBreakEntity(
            breakId: self.breakId,
            name: self.name,
            breakType: self.breakTypeEnum,
            podSize: self.podSize
        )
        return entity
    }
}
