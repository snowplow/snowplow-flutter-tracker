//
//  CreateTrackerMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 03/01/2022.
//

import Foundation
import SnowplowTracker

struct CreateTrackerMessageReader: Decodable {
    let namespace: String
    let networkConfig: NetworkConfigurationReader
    let trackerConfig: TrackerConfigurationReader?
    let subjectConfig: SubjectConfigurationReader?
    let gdprConfig: GdprConfigurationReader?
}
