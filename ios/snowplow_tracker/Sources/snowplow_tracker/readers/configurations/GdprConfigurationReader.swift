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
