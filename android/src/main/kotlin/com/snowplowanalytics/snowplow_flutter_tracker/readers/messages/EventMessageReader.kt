package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

import com.snowplowanalytics.snowplow.event.*
import com.snowplowanalytics.snowplow.payload.SelfDescribingJson
import com.snowplowanalytics.snowplow_flutter_tracker.readers.events.*

class EventMessageReader(val values: Map<String, Any>) {
    val tracker: String by values
    private val eventData: Map<String, Any> by values
    private val contexts: List<Map<String, Any>>? by values
    private val contextsJsons: List<SelfDescribingJson>? by lazy {
        contexts?.let { it.map { item -> SelfDescribingJsonReader(item).toSelfDescribingJson() } }
    }

    fun toStructuredWithContexts(): Structured {
        val structured = StructuredReader(eventData).toStructured()
        contextsJsons?.let { structured.customContexts.addAll(it) }
        return structured
    }

    fun toSelfDescribingWithContexts(): SelfDescribing {
        val selfDescribing = SelfDescribingJsonReader(eventData).toSelfDescribing()
        contextsJsons?.let { selfDescribing.customContexts.addAll(it) }
        return selfDescribing
    }

    fun toScreenViewWithContexts(): ScreenView {
        val screenView = ScreenViewReader(eventData).toScreenView()
        contextsJsons?.let { screenView.customContexts.addAll(it) }
        return screenView
    }

    fun toTimingWithContexts(): Timing {
        val timing = TimingReader(eventData).toTiming()
        contextsJsons?.let { timing.customContexts.addAll(it) }
        return timing
    }

    fun toConsentGrantedWithContexts(): ConsentGranted {
        val consentGranted = ConsentGrantedReader(eventData).toConsentGranted()
        contextsJsons?.let { consentGranted.customContexts.addAll(it) }
        return consentGranted
    }

    fun toConsentWithdrawnWithContexts(): ConsentWithdrawn {
        val consentWithdrawn = ConsentWithdrawnReader(eventData).toConsentWithdrawn()
        contextsJsons?.let { consentWithdrawn.customContexts.addAll(it) }
        return consentWithdrawn
    }
}