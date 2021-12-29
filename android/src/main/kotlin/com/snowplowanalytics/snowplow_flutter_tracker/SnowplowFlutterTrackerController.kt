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

        val sessionConfigReader = messageReader.sessionConfig
        sessionConfigReader?.let { controllers.add(it.toConfiguration()) }

        val emitterConfigReader = messageReader.emitterConfig
        emitterConfigReader?.let { controllers.add(it.toConfiguration()) }

        val subjectConfigReader = messageReader.subjectConfig
        subjectConfigReader?.let { controllers.add(it.toConfiguration()) }

        val gdprConfigReader = messageReader.gdprConfig
        gdprConfigReader?.let { controllers.add(it.toConfiguration()) }

        val globalContextsConfiguration = messageReader.toGlobalContextsConfiguration()
        globalContextsConfiguration?.let { controllers.add(it) }

        Snowplow.createTracker(
                context,
                messageReader.namespace,
                networkConfiguration,
                *controllers.toTypedArray()
        )
    }

    fun removeTracker(values: Map<String, Any>) {
        val messageReader = RemoveTrackerMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)
        trackerController?.let { Snowplow.removeTracker(it) }
    }

    fun removeAllTrackers() {
        Snowplow.removeAllTrackers()
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

    fun setNetworkUserId(values: Map<String, Any>) {
        val messageReader = SetNetworkUserIdMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.networkUserId = messageReader.networkUserId
    }

    fun setDomainUserId(values: Map<String, Any>) {
        val messageReader = SetDomainUserIdMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.domainUserId = messageReader.domainUserId
    }

    fun setIpAddress(values: Map<String, Any>) {
        val messageReader = SetIpAddressMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.ipAddress = messageReader.ipAddress
    }

    fun setUseragent(values: Map<String, Any>) {
        val messageReader = SetUseragentMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.useragent = messageReader.useragent
    }

    fun setTimezone(values: Map<String, Any>) {
        val messageReader = SetTimezoneMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.timezone = messageReader.timezone
    }

    fun setLanguage(values: Map<String, Any>) {
        val messageReader = SetLanguageMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.language = messageReader.language
    }

    fun setScreenResolution(values: Map<String, Any>) {
        val messageReader = SetScreenResolutionMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.screenResolution = messageReader.screenResolutionSize
    }

    fun setScreenViewport(values: Map<String, Any>) {
        val messageReader = SetScreenViewportMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.screenViewPort = messageReader.screenViewportSize
    }

    fun setColorDepth(values: Map<String, Any>) {
        val messageReader = SetColorDepthMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.colorDepth = messageReader.colorDepth
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

    fun getIsInBackground(values: Map<String, Any>): Boolean? {
        val messageReader = GetParameterMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.isInBackground
    }

    fun getBackgroundIndex(values: Map<String, Any>): Int? {
        val messageReader = GetParameterMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.backgroundIndex
    }

    fun getForegroundIndex(values: Map<String, Any>): Int? {
        val messageReader = GetParameterMessageReader(values)
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.foregroundIndex
    }

}
