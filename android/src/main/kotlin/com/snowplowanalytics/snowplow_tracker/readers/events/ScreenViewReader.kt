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

package com.snowplowanalytics.snowplow_tracker.readers.events

import com.snowplowanalytics.snowplow.event.ScreenView
import java.util.*

class ScreenViewReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val name: String by values
    private val id: String? by valuesDefault
    val idUUID: UUID? by lazy { id?.let { UUID.fromString(it) } }
    val type: String? by valuesDefault
    val previousName: String? by valuesDefault
    val previousType: String? by valuesDefault
    val previousId: String? by valuesDefault
    val transitionType: String? by valuesDefault

    fun toScreenView(): ScreenView {
        val screenView = ScreenView(name, idUUID)
        type?.let { screenView.type(it) }
        previousName?.let { screenView.previousName(it) }
        previousType?.let { screenView.previousType(it) }
        previousId?.let { screenView.previousId(it) }
        transitionType?.let { screenView.transitionType(it) }
        return screenView
    }
}
