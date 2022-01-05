//
//  SessionConfigurationReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 03/01/2022.
//

import Foundation
import SnowplowTracker

struct SessionConfigurationReader: Decodable {
    let foregroundTimeout: Double
    let backgroundTimeout: Double
}

extension SessionConfigurationReader {
    func toConfiguration() -> SessionConfiguration {
        return SessionConfiguration(
            foregroundTimeoutInSeconds: Int(foregroundTimeout),
            backgroundTimeoutInSeconds: Int(backgroundTimeout)
        )
    }
}
