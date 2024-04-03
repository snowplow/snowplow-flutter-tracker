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
import com.snowplowanalytics.snowplow.media.event.*
import com.snowplowanalytics.snowplow.payload.SelfDescribingJson
import com.snowplowanalytics.snowplow_tracker.readers.entities.MediaAdBreakEntityReader
import com.snowplowanalytics.snowplow_tracker.readers.entities.MediaAdEntityReader
import com.snowplowanalytics.snowplow_tracker.readers.entities.MediaPlayerEntityReader
import com.snowplowanalytics.snowplow_tracker.readers.events.*

class EventMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    private val eventData: Map<String, Any> by values
    private val contexts: List<Map<String, Any>>? by valuesDefault
    private val contextsJsons: List<SelfDescribingJson>? by lazy {
        contexts?.let { it.map { item -> SelfDescribingJsonReader(item).toSelfDescribingJson() } }
    }
    val mediaTrackingId: String? by valuesDefault
    val player: MediaPlayerEntityReader? by lazy {
        values.get("player")?.let {
            MediaPlayerEntityReader(it as Map<String, Any>)
        }
    }
    val ad: MediaAdEntityReader? by lazy {
        values.get("ad")?.let {
            MediaAdEntityReader(it as Map<String, Any>)
        }
    }
    val adBreak: MediaAdBreakEntityReader? by lazy {
        values.get("adBreak")?.let {
            MediaAdBreakEntityReader(it as Map<String, Any>)
        }
    }

    fun toStructuredWithContexts(): Structured {
        val structured = StructuredReader(eventData).toStructured()
        addContext(structured)
        return structured
    }

    fun toSelfDescribingWithContexts(): SelfDescribing {
        val selfDescribing = SelfDescribingJsonReader(eventData).toSelfDescribing()
        addContext(selfDescribing)
        return selfDescribing
    }

    fun toScreenViewWithContexts(): ScreenView {
        val screenView = ScreenViewReader(eventData).toScreenView()
        addContext(screenView)
        return screenView
    }

    fun toScrollChangedWithContexts(): ScrollChanged {
        val scrollChanged = ScrollChangedReader(eventData).toScrollChanged()
        addContext(scrollChanged)
        return scrollChanged
    }

    fun toListItemViewWithContexts(): ListItemView {
        val listItemView = ListItemViewReader(eventData).toListItemView()
        addContext(listItemView)
        return listItemView
    }

    fun toTimingWithContexts(): Timing {
        val timing = TimingReader(eventData).toTiming()
        addContext(timing)
        return timing
    }

    fun toConsentGrantedWithContexts(): ConsentGranted {
        val consentGranted = ConsentGrantedReader(eventData).toConsentGranted()
        addContext(consentGranted)
        return consentGranted
    }

    fun toConsentWithdrawnWithContexts(): ConsentWithdrawn {
        val consentWithdrawn = ConsentWithdrawnReader(eventData).toConsentWithdrawn()
        addContext(consentWithdrawn)
        return consentWithdrawn
    }

    fun toMediaAdBreakEndEvent(): MediaAdBreakEndEvent {
        val event = MediaAdBreakEndEvent()
        addContext(event)
        return event
    }

    fun toMediaAdBreakStartEvent(): MediaAdBreakStartEvent {
        val event = MediaAdBreakStartEvent()
        addContext(event)
        return event
    }

    fun toMediaAdClickEvent(): MediaAdClickEvent {
        val event = MediaAdEventReader(eventData).toMediaAdClickEvent()
        addContext(event)
        return event
    }

    fun toMediaAdCompleteEvent(): MediaAdCompleteEvent {
        val event = MediaAdCompleteEvent()
        addContext(event)
        return event
    }

    fun toMediaAdFirstQuartileEvent(): MediaAdFirstQuartileEvent {
        val event = MediaAdFirstQuartileEvent()
        addContext(event)
        return event
    }

    fun toMediaAdMidpointEvent(): MediaAdMidpointEvent {
        val event = MediaAdMidpointEvent()
        addContext(event)
        return event
    }

    fun toMediaAdPauseEvent(): MediaAdPauseEvent {
        val event = MediaAdEventReader(eventData).toMediaAdPauseEvent()
        addContext(event)
        return event
    }

    fun toMediaAdResumeEvent(): MediaAdResumeEvent {
        val event = MediaAdEventReader(eventData).toMediaAdResumeEvent()
        addContext(event)
        return event
    }

    fun toMediaAdSkipEvent(): MediaAdSkipEvent {
        val event = MediaAdEventReader(eventData).toMediaAdSkipEvent()
        addContext(event)
        return event
    }

    fun toMediaAdStartEvent(): MediaAdStartEvent {
        val event = MediaAdStartEvent()
        addContext(event)
        return event
    }

    fun toMediaAdThirdQuartileEvent(): MediaAdThirdQuartileEvent {
        val event = MediaAdThirdQuartileEvent()
        addContext(event)
        return event
    }

    fun toMediaBufferEndEvent(): MediaBufferEndEvent {
        val event = MediaBufferEndEvent()
        addContext(event)
        return event
    }

    fun toMediaBufferStartEvent(): MediaBufferStartEvent {
        val event = MediaBufferStartEvent()
        addContext(event)
        return event
    }

    fun toMediaEndEvent(): MediaEndEvent {
        val event = MediaEndEvent()
        addContext(event)
        return event
    }

    fun toMediaErrorEvent(): MediaErrorEvent {
        val event = MediaErrorEventReader(eventData).toMediaErrorEvent()
        addContext(event)
        return event
    }

    fun toMediaFullscreenChangeEvent(): MediaFullscreenChangeEvent {
        val event = MediaFullscreenChangeEventReader(eventData).toMediaFullscreenChangeEvent()
        addContext(event)
        return event
    }

    fun toMediaPauseEvent(): MediaPauseEvent {
        val event = MediaPauseEvent()
        addContext(event)
        return event
    }

    fun toMediaPictureInPictureChangeEvent(): MediaPictureInPictureChangeEvent {
        val event = MediaPictureInPictureChangeEventReader(eventData).toMediaPictureInPictureChangeEvent()
        addContext(event)
        return event
    }

    fun toMediaPlayEvent(): MediaPlayEvent {
        val event = MediaPlayEvent()
        addContext(event)
        return event
    }

    fun toMediaPlaybackRateChangeEvent(): MediaPlaybackRateChangeEvent {
        val event = MediaPlaybackRateChangeEventReader(eventData).toMediaPlaybackRateChangeEvent()
        addContext(event)
        return event
    }

    fun toMediaQualityChangeEvent(): MediaQualityChangeEvent {
        val event = MediaQualityChangeEventReader(eventData).toMediaQualityChangeEvent()
        addContext(event)
        return event
    }

    fun toMediaReadyEvent(): MediaReadyEvent {
        val event = MediaReadyEvent()
        addContext(event)
        return event
    }

    fun toMediaSeekEndEvent(): MediaSeekEndEvent {
        val event = MediaSeekEndEvent()
        addContext(event)
        return event
    }

    fun toMediaSeekStartEvent(): MediaSeekStartEvent {
        val event = MediaSeekStartEvent()
        addContext(event)
        return event
    }

    fun toMediaVolumeChangeEvent(): MediaVolumeChangeEvent {
        val event = MediaVolumeChangeEventReader(eventData).toMediaVolumeChangeEvent()
        addContext(event)
        return event
    }

    private fun addContext(event: Event) {
        contextsJsons?.let { event.entities.addAll(it) }
    }
}
