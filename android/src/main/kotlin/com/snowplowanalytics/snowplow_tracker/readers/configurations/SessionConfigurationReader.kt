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

import com.snowplowanalytics.snowplow.configuration.SessionConfiguration
import com.snowplowanalytics.snowplow.util.TimeMeasure
import java.util.concurrent.TimeUnit

class SessionConfigurationReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val foregroundTimeout: Long? by lazy {
        (values["foregroundTimeout"] as? Number)?.toLong()
    }
    val backgroundTimeout: Long? by lazy {
        (values["backgroundTimeout"] as? Number)?.toLong()
    }
    val continueSessionOnRestart: Boolean? by valuesDefault

    fun toConfiguration(): SessionConfiguration {
        val sessionConfig = SessionConfiguration(
            foregroundTimeout?.let { TimeMeasure(it, TimeUnit.SECONDS) },
            backgroundTimeout?.let { TimeMeasure(it, TimeUnit.SECONDS) }
        )

        continueSessionOnRestart?.let { sessionConfig.continueSessionOnRestart(it) }

        return sessionConfig
    }
}
