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

package com.snowplowanalytics.snowplow_tracker.readers.entities

import com.snowplowanalytics.snowplow.media.entity.*

class MediaAdBreakEntityReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val name: String? by valuesDefault
    val breakId: String by values
    val breakType: String? by valuesDefault
    val podSize: Int? by valuesDefault

    val breakTypeEnum: MediaAdBreakType? by lazy {
        when (breakType) {
            "linear" -> MediaAdBreakType.Linear
            "nonLinear" -> MediaAdBreakType.NonLinear
            "companion" -> MediaAdBreakType.Companion
            else -> null
        }
    }

    fun toMediaAdBreakEntity(): MediaAdBreakEntity {
        return MediaAdBreakEntity(
            breakId = breakId,
            name = name,
            breakType = breakTypeEnum,
            podSize = podSize
        )
    }
}
