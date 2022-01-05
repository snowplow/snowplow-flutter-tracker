//
//  ConsentDocumentReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct ConsentDocumentReader: Decodable {
    let documentId: String
    let documentVersion: String
    let documentName: String?
    let documentDescription: String?
}

extension ConsentDocumentReader {
    func toConsentDocument() -> ConsentDocument {
        let document = ConsentDocument(documentId: documentId, version: documentVersion)
        if let name = self.documentName { document.name(name) }
        if let description = self.documentDescription { document.documentDescription(description) }
        return document
    }
}
