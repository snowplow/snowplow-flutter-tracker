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

class TrackerConfigurationReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val appId: String? by valuesDefault
    val devicePlatform: String? by valuesDefault
    val base64Encoding: Boolean? by valuesDefault
    val platformContext: Boolean? by valuesDefault
    val geoLocationContext: Boolean? by valuesDefault
    val sessionContext: Boolean? by valuesDefault
    val userAnonymisation: Boolean? by valuesDefault
    val screenContext: Boolean? by valuesDefault
    val applicationContext: Boolean? by valuesDefault
    val lifecycleAutotracking: Boolean? by valuesDefault
    val screenEngagementAutotracking: Boolean? by valuesDefault
    val platformContextProperties: Map<String, Any>? by valuesDefault
    private val platformContextRetriever: PlatformContextRetriever? by lazy {
        platformContextProperties?.let { PlatformContextPropertiesReader(it).toPlatformContextRetriever() }
    }

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
        userAnonymisation?.let { trackerConfig.userAnonymisation(it) }
        screenContext?.let { trackerConfig.screenContext(it) }
        applicationContext?.let { trackerConfig.applicationContext(it) }
        lifecycleAutotracking?.let { trackerConfig.lifecycleAutotracking(it) }
        screenEngagementAutotracking?.let { trackerConfig.screenEngagementAutotracking(it) }
        platformContextRetriever?.let { trackerConfig.platformContextRetriever(it) }

        return trackerConfig
    }
}

object DefaultTrackerConfiguration {
    fun toConfiguration(appId: String?, context: Context): TrackerConfiguration {
        val trackerConfig = TrackerConfiguration(appId ?: context.getPackageName())
                .trackerVersionSuffix(TrackerVersion.TRACKER_VERSION)
        
        trackerConfig.screenViewAutotracking(false)
        trackerConfig.lifecycleAutotracking(true)
        trackerConfig.screenEngagementAutotracking(true)
        trackerConfig.installAutotracking(false)
        trackerConfig.exceptionAutotracking(false)
        trackerConfig.diagnosticAutotracking(false)

        return trackerConfig
    }
}
