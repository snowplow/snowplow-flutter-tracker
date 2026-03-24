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

import com.snowplowanalytics.snowplow.configuration.GlobalContextsConfiguration
import com.snowplowanalytics.snowplow.globalcontexts.GlobalContext
import com.snowplowanalytics.snowplow_tracker.readers.events.SelfDescribingJsonReader

class GlobalContextsConfigurationReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }
    val contexts: List<Map<String, Any>>? by valuesDefault

    fun toConfiguration(): GlobalContextsConfiguration {
        val staticContexts = contexts?.map { item ->
            SelfDescribingJsonReader(item).toSelfDescribingJson()
        } ?: emptyList()

        return GlobalContextsConfiguration(
            mutableMapOf("flutter-global" to GlobalContext(staticContexts))
        )
    }
}
