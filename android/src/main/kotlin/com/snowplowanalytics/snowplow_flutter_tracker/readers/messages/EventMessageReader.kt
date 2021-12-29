package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

import com.snowplowanalytics.snowplow.event.*
import com.snowplowanalytics.snowplow.payload.SelfDescribingJson
import com.snowplowanalytics.snowplow_flutter_tracker.readers.events.*

class EventMessageReader(val values: Map<String, Any>) {
    val tracker: String by values
    private val eventData: Map<String, Any> by values
    private val contexts: List<Map<String, Any>> by values
    private val contextsJsons: List<SelfDescribingJson> by lazy {
        contexts.map { item -> SelfDescribingJsonReader(item).toSelfDescribingJson() }
    }

    fun toStructuredWithContexts(): Structured {
        val structured = StructuredReader(eventData).toStructured()
        structured.customContexts.addAll(contextsJsons)
        return structured
    }

    fun toSelfDescribingWithContexts(): SelfDescribing {
        val selfDescribing = SelfDescribingJsonReader(eventData).toSelfDescribing()
        selfDescribing.customContexts.addAll(contextsJsons)
        return selfDescribing
    }

    fun toScreenViewWithContexts(): ScreenView {
        val screenView = ScreenViewReader(eventData).toScreenView()
        screenView.customContexts.addAll(contextsJsons)
        return screenView
    }

    fun toTimingWithContexts(): Timing {
        val timing = TimingReader(eventData).toTiming()
        timing.customContexts.addAll(contextsJsons)
        return timing
    }

    fun toConsentGrantedWithContexts(): ConsentGranted {
        val consentGranted = ConsentGrantedReader(eventData).toConsentGranted()
        consentGranted.customContexts.addAll(contextsJsons)
        return consentGranted
    }

    fun toConsentWithdrawnWithContexts(): ConsentWithdrawn {
        val consentWithdrawn = ConsentWithdrawnReader(eventData).toConsentWithdrawn()
        consentWithdrawn.customContexts.addAll(contextsJsons)
        return consentWithdrawn
    }
}