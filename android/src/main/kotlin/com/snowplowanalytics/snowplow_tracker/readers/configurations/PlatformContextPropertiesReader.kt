// Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

package com.snowplowanalytics.snowplow_tracker.readers.configurations

import android.content.Context
import com.snowplowanalytics.snowplow.configuration.TrackerConfiguration
import com.snowplowanalytics.snowplow.tracker.DevicePlatform
import com.snowplowanalytics.snowplow.tracker.PlatformContextRetriever
import com.snowplowanalytics.snowplow_tracker.TrackerVersion

class PlatformContextPropertiesReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val osType: String? by valuesDefault
    val osVersion: String? by valuesDefault
    val deviceVendor: String? by valuesDefault
    val deviceModel: String? by valuesDefault
    val carrier: String? by valuesDefault
    val networkType: String? by valuesDefault
    val networkTechnology: String? by valuesDefault
    val androidIdfa: String? by valuesDefault
    val availableStorage: String? by valuesDefault
    val totalStorage: String? by valuesDefault
    val physicalMemory: String? by valuesDefault
    val systemAvailableMemory: String? by valuesDefault
    val batteryLevel: Int? by valuesDefault
    val batteryState: String? by valuesDefault
    val isPortrait: Boolean? by valuesDefault
    val resolution: String? by valuesDefault
    val scale: Double? by valuesDefault
    val language: String? by valuesDefault
    val appSetId: String? by valuesDefault
    val appSetIdScope: String? by valuesDefault

    fun toPlatformContextRetriever(): PlatformContextRetriever {
        val retriever = PlatformContextRetriever()

        osType?.let { retriever.osType = { it } }
        osVersion?.let { retriever.osVersion = { it } }
        deviceVendor?.let { retriever.deviceVendor = { it } }
        deviceModel?.let { retriever.deviceModel = { it } }
        carrier?.let { retriever.carrier = { it } }
        networkType?.let { retriever.networkType = { it } }
        networkTechnology?.let { retriever.networkTechnology = { it } }
        androidIdfa?.let { retriever.androidIdfa = { it } }
        availableStorage?.let { retriever.availableStorage = { it.toLong() } }
        totalStorage?.let { retriever.totalStorage = { it.toLong() } }
        physicalMemory?.let { retriever.physicalMemory = { it.toLong() } }
        systemAvailableMemory?.let { retriever.systemAvailableMemory = { it.toLong() } }
        batteryLevel?.let { retriever.batteryLevel = { it } }
        batteryState?.let { retriever.batteryState = { it } }
        isPortrait?.let { retriever.isPortrait = { it } }
        resolution?.let { retriever.resolution = { it } }
        scale?.let { retriever.scale = { it.toFloat() } }
        language?.let { retriever.language = { it } }
        appSetId?.let { retriever.appSetId = { it } }
        appSetIdScope?.let { retriever.appSetIdScope = { it } }

        return retriever
    }
}
