//
//  GlobalContextsConfigurationReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 03/01/2022.
//

import Foundation
import SnowplowTracker

struct GlobalContextsConfigurationReader: Decodable {
    let tag: String
    let globalContexts: [SelfDescribingJsonReader]
}

extension GlobalContextsConfigurationReader {
    func toGlobalContext(arguments: [String: Any]) -> GlobalContext? {
        if let gcArguments = arguments["globalContexts"] as? [[String: Any]] {
            let staticContexts = zip(globalContexts, gcArguments).map { (reader, data) in
                reader.toSelfDescribingJson(arguments: data)
            }.compactMap { $0 }

            return GlobalContext(staticContexts: staticContexts)
        }
        return nil
    }
}
