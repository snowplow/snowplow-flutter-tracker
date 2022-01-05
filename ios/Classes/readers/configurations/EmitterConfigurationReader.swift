//
//  EmitterConfigurationReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 03/01/2022.
//

import Foundation
import SnowplowTracker

struct EmitterConfigurationReader: Decodable {
    let bufferOption: String?
    let emitRange: Double?
    let threadPoolSize: Double?
    let byteLimitPost: Double?
    let byteLimitGet: Double?
//    let mockEventStore: Bool?
    
    var bufferOptionType: BufferOption? {
        if let bufferOption = self.bufferOption {
            switch bufferOption {
            case "default":
                return .defaultGroup
            case "heavy":
                return .largeGroup
            case "large":
                return .largeGroup
            default:
                return .single
            }
        }
        return nil
    }
}

extension EmitterConfigurationReader {
    func toConfiguration() -> EmitterConfiguration {
        let configuration = EmitterConfiguration()
        if let bo = self.bufferOptionType { configuration.bufferOption(bo) }
        if let er = self.emitRange { configuration.emitRange(Int(er)) }
        if let tps = self.threadPoolSize { configuration.threadPoolSize(Int(tps)) }
        if let blp = self.byteLimitPost { configuration.byteLimitPost(Int(blp)) }
        if let blg = self.byteLimitGet { configuration.byteLimitGet(Int(blg)) }
        
        return configuration
    }
}
