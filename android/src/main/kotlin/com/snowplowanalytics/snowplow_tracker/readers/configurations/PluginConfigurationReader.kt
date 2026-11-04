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

import com.snowplowanalytics.core.tracker.TrackerEvent
import com.snowplowanalytics.snowplow.configuration.PluginConfiguration
import com.snowplowanalytics.snowplow.payload.SelfDescribingJson
import com.snowplowanalytics.snowplow.tracker.InspectableEvent
import com.snowplowanalytics.snowplow_tracker.PluginEntitiesStore
import com.snowplowanalytics.snowplow_tracker.readers.events.SelfDescribingJsonReader

class PluginConfigurationReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val identifier: String by values
    val afterTrack: Boolean? by valuesDefault
    val entities: List<SelfDescribingJson>? by lazy {
        (values.get("entities") as? List<Map<String, Any>>)?.map {
            SelfDescribingJsonReader(it).toSelfDescribingJson()
        }
    }

    fun toConfiguration(
        afterTrackCallback: (String, InspectableEvent) -> Unit,
        entitiesStore: PluginEntitiesStore?
    ): PluginConfiguration {
        val plugin = PluginConfiguration(identifier)
        if (afterTrack == true) {
            plugin.afterTrack { event -> afterTrackCallback(identifier, event) }
        }
        entitiesStore?.let { store ->
            // TrackerEvent.timestamp is when the event was tracked, InspectableEvent doesn't expose it
            plugin.entities { event -> store.entitiesAt((event as? TrackerEvent)?.timestamp) }
        }
        return plugin
    }
}
