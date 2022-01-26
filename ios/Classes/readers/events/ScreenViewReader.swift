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

struct ScreenViewReader: Decodable {
    let name: String
    let id: String?
    let type: String?
    let previousName: String?
    let previousType: String?
    let previousId: String?
    let transitionType: String?
    
    var idUUID: UUID? {
        if let id = self.id {
            return UUID(uuidString: id)
        }
        return nil
    }
}

extension ScreenViewReader {
    func toScreenView() -> ScreenView {
        let event = ScreenView(name: name, screenId: idUUID)
        if let t = self.type { event.type(t) }
        if let pn = self.previousName { event.previousName(pn) }
        if let pt = self.previousType { event.previousType(pt) }
        if let pi = self.previousId { event.previousId(pi) }
        if let tt = self.transitionType { event.transitionType(tt) }
        return event
    }
}
