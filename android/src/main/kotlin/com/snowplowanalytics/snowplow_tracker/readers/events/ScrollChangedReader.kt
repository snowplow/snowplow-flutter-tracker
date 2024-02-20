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

package com.snowplowanalytics.snowplow_tracker.readers.events

import com.snowplowanalytics.snowplow.event.ScrollChanged
import java.util.*

class ScrollChangedReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val yOffset: Int? by valuesDefault
    val xOffset: Int? by valuesDefault
    val viewWidth: Int? by valuesDefault
    val viewHeight: Int? by valuesDefault
    val contentWidth: Int? by valuesDefault
    val contentHeight: Int? by valuesDefault

    fun toScrollChanged(): ScrollChanged {
        val scrollChanged = ScrollChanged(
            yOffset = yOffset,
            xOffset = xOffset,
            viewWidth = viewWidth,
            viewHeight = viewHeight,
            contentWidth = contentWidth,
            contentHeight = contentHeight
        )
        return scrollChanged
    }
}
