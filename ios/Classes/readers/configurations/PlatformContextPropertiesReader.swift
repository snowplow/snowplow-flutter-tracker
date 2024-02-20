// Copyright (c) 2022 Snowplow Analytics Ltd. All rights reserved.
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

struct PlatformContextPropertiesReader: Decodable {
    let osType: String?
    let osVersion: String?
    let deviceVendor: String?
    let deviceModel: String?
    let carrier: String?
    let networkType: String?
    let networkTechnology: String?
    let appleIdfa: String?
    let appleIdfv: String?
    let availableStorage: String?;
    let totalStorage: String?
    let physicalMemory: String?
    let appAvailableMemory: Int?
    let batteryLevel: Int?
    let batteryState: String?
    let lowPowerMode: Bool?
    let isPortrait: Bool?
    let resolution: String?
    let scale: Double?
    let language: String?
}

extension PlatformContextPropertiesReader {
    func toPlatformContextRetriever() -> PlatformContextRetriever {
        let retriever = PlatformContextRetriever()

        if let osType = self.osType { retriever.osType = { osType } }
        if let osVersion = self.osVersion { retriever.osVersion = { osVersion } }
        if let deviceVendor = self.deviceVendor { retriever.deviceVendor = { deviceVendor } }
        if let deviceModel = self.deviceModel { retriever.deviceModel = { deviceModel } }
        if let carrier = self.carrier { retriever.carrier = { carrier } }
        if let networkType = self.networkType { retriever.networkType = { networkType } }
        if let networkTechnology = self.networkTechnology { retriever.networkTechnology = { networkTechnology } }
        if let appleIdfa = self.appleIdfa {
            if let uuid = UUID(uuidString: appleIdfa) {
                retriever.appleIdfa = { uuid }
            }
        }
        if let appleIdfv = self.appleIdfv { retriever.appleIdfv = { appleIdfv } }
        if let availableStorage = self.availableStorage { retriever.availableStorage = { Int64(availableStorage) } }
        if let totalStorage = self.totalStorage { retriever.totalStorage = { Int64(totalStorage) } }
        if let physicalMemory = self.physicalMemory { retriever.physicalMemory = { UInt64(physicalMemory) } }
        if let appAvailableMemory = self.appAvailableMemory { retriever.appAvailableMemory = { appAvailableMemory } }
        if let batteryLevel = self.batteryLevel { retriever.batteryLevel = { batteryLevel } }
        if let batteryState = self.batteryState { retriever.batteryState = { batteryState } }
        if let lowPowerMode = self.lowPowerMode { retriever.lowPowerMode = { lowPowerMode } }
        if let isPortrait = self.isPortrait { retriever.isPortrait = { isPortrait } }
        if let resolution = self.resolution { retriever.resolution = { resolution } }
        if let scale = self.scale { retriever.scale = { scale } }
        if let language = self.language { retriever.language = { language } }

        return retriever
    }
}
