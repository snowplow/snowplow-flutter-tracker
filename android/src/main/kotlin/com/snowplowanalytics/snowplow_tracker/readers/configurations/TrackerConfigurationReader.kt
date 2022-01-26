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

package com.snowplowanalytics.snowplow_tracker.readers.configurations

import android.content.Context
import com.snowplowanalytics.snowplow.configuration.TrackerConfiguration
import com.snowplowanalytics.snowplow.tracker.DevicePlatform
import com.snowplowanalytics.snowplow_tracker.TrackerVersion

class TrackerConfigurationReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val appId: String? by valuesDefault
    val devicePlatform: String? by valuesDefault
    val base64Encoding: Boolean? by valuesDefault
    val platformContext: Boolean? by valuesDefault
    val geoLocationContext: Boolean? by valuesDefault
    val sessionContext: Boolean? by valuesDefault

    fun toConfiguration(context: Context): TrackerConfiguration {
        val trackerConfig = DefaultTrackerConfiguration.toConfiguration(appId, context)

        devicePlatform?.let {
            trackerConfig.devicePlatform(when (it) {
                "web" -> DevicePlatform.Web
                "srv" -> DevicePlatform.ServerSideApp
                "pc" -> DevicePlatform.Desktop
                "app" -> DevicePlatform.General
                "tv" -> DevicePlatform.ConnectedTV
                "cnsl" -> DevicePlatform.GameConsole
                "iot" -> DevicePlatform.InternetOfThings
                else -> trackerConfig.devicePlatform
            })
        }
        base64Encoding?.let { trackerConfig.base64encoding(it) }
        platformContext?.let { trackerConfig.platformContext(it) }
        geoLocationContext?.let { trackerConfig.geoLocationContext(it) }
        sessionContext?.let { trackerConfig.sessionContext(it) }

        return trackerConfig
    }
}

object DefaultTrackerConfiguration {
    fun toConfiguration(appId: String?, context: Context): TrackerConfiguration {
        val trackerConfig = TrackerConfiguration(appId ?: context.getPackageName())
                .trackerVersionSuffix(TrackerVersion.TRACKER_VERSION)

        trackerConfig.applicationContext(false)
        trackerConfig.screenContext(false)
        trackerConfig.screenViewAutotracking(false)
        trackerConfig.lifecycleAutotracking(false)
        trackerConfig.installAutotracking(false)
        trackerConfig.exceptionAutotracking(false)
        trackerConfig.diagnosticAutotracking(false)

        return trackerConfig
    }
}
