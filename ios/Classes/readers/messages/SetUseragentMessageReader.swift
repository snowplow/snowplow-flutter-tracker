//
//  SetUseragentMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation

struct SetUseragentMessageReader: Decodable {
    let tracker: String
    let useragent: String?
}
