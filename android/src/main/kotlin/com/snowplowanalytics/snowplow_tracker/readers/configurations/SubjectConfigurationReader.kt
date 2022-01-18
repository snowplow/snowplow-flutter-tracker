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

import com.snowplowanalytics.snowplow.configuration.SubjectConfiguration
import com.snowplowanalytics.snowplow.util.Size

class SubjectConfigurationReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val userId: String? by valuesDefault
    val networkUserId: String? by valuesDefault
    val domainUserId: String? by valuesDefault
    val userAgent: String? by valuesDefault
    val ipAddress: String? by valuesDefault
    val timezone: String? by valuesDefault
    val language: String? by valuesDefault
    val screenResolution: Pair<Double, Double>? by valuesDefault
    val screenViewport: Pair<Double, Double>? by valuesDefault
    val colorDepth: Double? by valuesDefault

    val screenResolutionSize: Size? by lazy {
        screenResolution?.let {
            val screenWidth = it.first.toInt()
            val screenHeight = it.second.toInt()
            Size(screenWidth, screenHeight)
        }
    }
    val screenViewportSize: Size? by lazy {
        screenViewport?.let {
            val screenVPWidth = it.first.toInt()
            val screenVPHeight = it.second.toInt()
            Size(screenVPWidth, screenVPHeight)
        }
    }

    fun toConfiguration(): SubjectConfiguration {
        val subjectConfig = SubjectConfiguration()

        userId?.let { subjectConfig.userId(it) }
        networkUserId?.let { subjectConfig.networkUserId(it) }
        domainUserId?.let { subjectConfig.domainUserId(it) }
        userAgent?.let { subjectConfig.useragent(it) }
        ipAddress?.let { subjectConfig.ipAddress(it) }
        timezone?.let { subjectConfig.timezone(it) }
        language?.let { subjectConfig.language(it) }
        screenResolutionSize?.let { subjectConfig.screenResolution(it) }
        screenViewportSize?.let { subjectConfig.screenViewPort(it) }
        colorDepth?.let { subjectConfig.colorDepth(it.toInt()) }

        return subjectConfig
    }
}
