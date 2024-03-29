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

package com.snowplowanalytics.snowplow_tracker.readers.messages

import com.snowplowanalytics.snowplow.event.*
import com.snowplowanalytics.snowplow.payload.SelfDescribingJson
import com.snowplowanalytics.snowplow_tracker.readers.events.*

class EventMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    private val eventData: Map<String, Any> by values
    private val contexts: List<Map<String, Any>>? by valuesDefault
    private val contextsJsons: List<SelfDescribingJson>? by lazy {
        contexts?.let { it.map { item -> SelfDescribingJsonReader(item).toSelfDescribingJson() } }
    }

    fun toStructuredWithContexts(): Structured {
        val structured = StructuredReader(eventData).toStructured()
        contextsJsons?.let { structured.entities.addAll(it) }
        return structured
    }

    fun toSelfDescribingWithContexts(): SelfDescribing {
        val selfDescribing = SelfDescribingJsonReader(eventData).toSelfDescribing()
        contextsJsons?.let { selfDescribing.entities.addAll(it) }
        return selfDescribing
    }

    fun toScreenViewWithContexts(): ScreenView {
        val screenView = ScreenViewReader(eventData).toScreenView()
        contextsJsons?.let { screenView.entities.addAll(it) }
        return screenView
    }

    fun toScrollChangedWithContexts(): ScrollChanged {
        val scrollChanged = ScrollChangedReader(eventData).toScrollChanged()
        contextsJsons?.let { scrollChanged.entities.addAll(it) }
        return scrollChanged
    }

    fun toListItemViewWithContexts(): ListItemView {
        val listItemView = ListItemViewReader(eventData).toListItemView()
        contextsJsons?.let { listItemView.entities.addAll(it) }
        return listItemView
    }

    fun toTimingWithContexts(): Timing {
        val timing = TimingReader(eventData).toTiming()
        contextsJsons?.let { timing.entities.addAll(it) }
        return timing
    }

    fun toConsentGrantedWithContexts(): ConsentGranted {
        val consentGranted = ConsentGrantedReader(eventData).toConsentGranted()
        contextsJsons?.let { consentGranted.entities.addAll(it) }
        return consentGranted
    }

    fun toConsentWithdrawnWithContexts(): ConsentWithdrawn {
        val consentWithdrawn = ConsentWithdrawnReader(eventData).toConsentWithdrawn()
        contextsJsons?.let { consentWithdrawn.entities.addAll(it) }
        return consentWithdrawn
    }
}
