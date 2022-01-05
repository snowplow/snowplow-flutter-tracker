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
    let sessionConfig: SessionConfigurationReader?
    let emitterConfig: EmitterConfigurationReader?
    let subjectConfig: SubjectConfigurationReader?
    let gdprConfig: GdprConfigurationReader?
    let gcConfig: [GlobalContextsConfigurationReader]?
}

extension CreateTrackerMessageReader {
    func toGlobalContextsConfiguration(arguments: [String: Any]) -> GlobalContextsConfiguration? {
        if let readers = self.gcConfig,
           let readersArgs = arguments["gcConfig"] as? [[String: Any]] {
            let config = GlobalContextsConfiguration()
            
            for (reader, readerArgs) in zip(readers, readersArgs) {
                if let globalContext = reader.toGlobalContext(arguments: readerArgs) {
                    config.add(tag: reader.tag, contextGenerator: globalContext)
                }
            }
            
            return config
        }

        return nil
    }
}
