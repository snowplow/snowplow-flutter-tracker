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
