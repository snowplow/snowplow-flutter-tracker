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

import com.snowplowanalytics.snowplow.media.entity.MediaAdEntity

class MediaAdEntityReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val name: String? by valuesDefault
    val adId: String by values
    val creativeId: String? by valuesDefault
    val podPosition: Int? by valuesDefault
    val duration: Double? by valuesDefault
    val skippable: Boolean? by valuesDefault

    fun toMediaAdEntity(): MediaAdEntity {
        return MediaAdEntity(
            adId = adId,
            name = name,
            creativeId = creativeId,
            podPosition = podPosition,
            duration = duration,
            skippable = skippable
        )
    }
}
