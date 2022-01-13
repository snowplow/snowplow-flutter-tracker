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

package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.Structured

class StructuredReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val category: String by values
    val action: String by values
    val label: String? by valuesDefault
    val property: String? by valuesDefault
    val value: Double? by valuesDefault

    fun toStructured(): Structured {
        val structured = Structured(category, action)
        label?.let { structured.label(it) }
        property?.let { structured.property(it) }
        value?.let { structured.value(it) }
        return structured
    }
}
