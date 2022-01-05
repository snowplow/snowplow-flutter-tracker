//
//  NetworkConfigurationReader.swift
//  FMDB
//
//  Created by Matus Tomlein on 03/01/2022.
//

import Foundation
import SnowplowTracker

struct NetworkConfigurationReader: Decodable {
    let endpoint: String
    let method: String?
}

extension NetworkConfigurationReader {
    func toConfiguration() -> NetworkConfiguration {
        if let m = method {
            return NetworkConfiguration(endpoint: endpoint, method: m == "get" ? .get : .post)
        } else {
            return NetworkConfiguration(endpoint: endpoint, method: .post)
        }
    }
}
