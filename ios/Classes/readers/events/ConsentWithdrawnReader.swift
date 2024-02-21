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

struct ConsentWithdrawnReader: Decodable {
    let all: Bool
    let documentId: String
    let version: String
    let name: String?
    let documentDescription: String?
    let consentDocuments: [ConsentDocumentReader]?
}

extension ConsentWithdrawnReader {
    func toConsentWithdrawn() -> ConsentWithdrawn {
        let event = ConsentWithdrawn()
            .all(all)
            .documentId(documentId)
            .version(version)
        if let name = self.name { event.name(name) }
        if let description = self.documentDescription { event.documentDescription(description) }
        if let documents = self.consentDocuments {
            let jsons = documents.map { $0.toConsentDocument().payload }
            event.documents(jsons)
        }
        return event
    }
}
