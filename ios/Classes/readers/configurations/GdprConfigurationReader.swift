//
//  GdprConfigurationReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 03/01/2022.
//

import Foundation
import SnowplowTracker

struct GdprConfigurationReader: Decodable {
    let basisForProcessing: String
    let documentId: String
    let documentVersion: String
    let documentDescription: String
    
    var basisForProcessingType: GDPRProcessingBasis {
        switch (basisForProcessing) {
        case "contract":
            return .contract
        case "legal_obligation":
            return .legalObligation
        case "legitimate_interests":
            return .legitimateInterests
        case "public_task":
            return .publicTask
        case "vital_interests":
            return .vitalInterest
        default:
            return .consent
        }
    }
}

extension GdprConfigurationReader {
    func toConfiguration() -> GDPRConfiguration {
        return GDPRConfiguration(
            basis: basisForProcessingType,
            documentId: documentId,
            documentVersion: documentVersion,
            documentDescription: documentDescription
        )
    }
}
