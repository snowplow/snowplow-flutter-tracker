//
//  SetLanguageMessageReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation

struct SetLanguageMessageReader: Decodable {
    let tracker: String
    let language: String?
}
