//
//  SetUserIdMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation

struct SetUserIdMessageReader: Decodable {
    let tracker: String
    let userId: String?
}
