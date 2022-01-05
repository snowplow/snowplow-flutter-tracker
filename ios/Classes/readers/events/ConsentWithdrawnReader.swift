//
//  ConsentWithdrawnReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

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
            let jsons = documents.map { $0.toConsentDocument().getPayload() }
            event.documents(jsons)
        }
        return event
    }
}
