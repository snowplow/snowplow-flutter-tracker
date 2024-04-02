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

import com.snowplowanalytics.snowplow.media.configuration.MediaTrackingConfiguration
import com.snowplowanalytics.snowplow.payload.SelfDescribingJson
import com.snowplowanalytics.snowplow_tracker.readers.entities.MediaPlayerEntityReader
import com.snowplowanalytics.snowplow_tracker.readers.events.SelfDescribingJsonReader

class MediaTrackingConfigurationReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val id: String by values
    val player: MediaPlayerEntityReader? by lazy {
        values.get("player")?.let {
            MediaPlayerEntityReader(it as Map<String, Any>)
        }
    }
    val pings: Boolean by values
    val pingInterval: Int? by valuesDefault
    val maxPausedPings: Int? by valuesDefault
    val session: Boolean by values
    val boundaries: List<Int>? by valuesDefault
    val contexts: List<Map<String, Any>>? by valuesDefault
    val contextsJsons: List<SelfDescribingJson>? by lazy {
        contexts?.let { it.map { item -> SelfDescribingJsonReader(item).toSelfDescribingJson() } }
    }

    fun toConfiguration(): MediaTrackingConfiguration {
        return MediaTrackingConfiguration(
            id = id,
            player = player?.toMediaPlayerEntity(),
            pings = pings,
            pingInterval = pingInterval,
            maxPausedPings = maxPausedPings,
            session = session,
            boundaries = boundaries,
            entities = contextsJsons
        )
    }
}
