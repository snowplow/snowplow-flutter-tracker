package com.snowplowanalytics.snowplow_flutter_tracker

import android.content.Context

import com.snowplowanalytics.snowplow.Snowplow;
import com.snowplowanalytics.snowplow.configuration.Configuration;
import com.snowplowanalytics.snowplow_flutter_tracker.readers.messages.*

object SnowplowFlutterTrackerController {

    fun createTracker(values: Map<String, Any>, context: Context) {
        val messageReader = CreateTrackerMessageReader(values)
        val controllers: MutableList<Configuration> = mutableListOf()

        val networkConfigReader = messageReader.networkConfig;
        val networkConfiguration = networkConfigReader.toConfiguration()

        val trackerConfigReader = messageReader.trackerConfig
        trackerConfigReader?.let { controllers.add(it.toConfiguration(context)) }

        val subjectConfigReader = messageReader.subjectConfig
        subjectConfigReader?.let { controllers.add(it.toConfiguration()) }

        val gdprConfigReader = messageReader.gdprConfig
        gdprConfigReader?.let { controllers.add(it.toConfiguration()) }

        Snowplow.createTracker(
                context,
                messageReader.namespace,
                networkConfiguration,
                *controllers.toTypedArray()
        )
    }

    fun trackStructured(values: Map<String, Any>) {
        val eventReader = EventMessageReader(values)
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val structured = eventReader.toStructuredWithContexts()

        trackerController?.track(structured)
    }

    fun trackSelfDescribing(values: Map<String, Any>) {
        val eventReader = EventMessageReader(values)
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val selfDescribing = eventReader.toSelfDescribingWithContexts()

        trackerController?.track(selfDescribing)
    }

    fun trackScreenView(values: Map<String, Any>) {
        val eventReader = EventMessageReader(values)
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val screenView = eventReader.toScreenViewWithContexts()

        trackerController?.track(screenView)
    }

    fun trackTiming(values: Map<String, Any>) {
        val eventReader = EventMessageReader(values)
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val timing = eventReader.toTimingWithContexts()

        trackerController?.track(timing)
    }

    fun trackConsentGranted(values: Map<String, Any>) {
        val eventReader = EventMessageReader(values)
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val consentGranted = eventReader.toConsentGrantedWithContexts()

        trackerController?.track(consentGranted)
    }

    fun trackConsentWithdrawn(values: Map<String, Any>) {
        val eventReader = EventMessageReader(values)
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val consentWithdrawn = eventReader.toConsentWithdrawnWithContexts()

        trackerController?.track(consentWithdrawn)
    }

    fun setUserId(values: Map<String, Any>) {
        val messageReader = SetUserIdMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.userId = messageReader.userId
    }

    fun getSessionUserId(values: Map<String, Any>): String? {
        val messageReader = GetParameterMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.userId
    }

    fun getSessionId(values: Map<String, Any>): String? {
        val messageReader = GetParameterMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.sessionId
    }

    fun getSessionIndex(values: Map<String, Any>): Int? {
        val messageReader = GetParameterMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.sessionIndex
    }

}
