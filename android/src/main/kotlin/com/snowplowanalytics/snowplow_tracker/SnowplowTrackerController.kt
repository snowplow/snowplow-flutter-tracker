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

package com.snowplowanalytics.snowplow_tracker

import android.content.Context
import com.snowplowanalytics.core.event.WebViewReader

import com.snowplowanalytics.snowplow.Snowplow;
import com.snowplowanalytics.snowplow.configuration.Configuration;
import com.snowplowanalytics.snowplow.event.Event
import com.snowplowanalytics.snowplow_tracker.readers.configurations.DefaultTrackerConfiguration
import com.snowplowanalytics.snowplow_tracker.readers.messages.*
import com.snowplowanalytics.snowplow_tracker.readers.events.SelfDescribingJsonReader
import com.snowplowanalytics.snowplow.globalcontexts.GlobalContext
import com.snowplowanalytics.snowplow.tracker.InspectableEvent

object SnowplowTrackerController {

    /// Receives the arguments of the afterTrack callbacks to send to Dart
    var afterTrackListener: ((Map<String, Any?>) -> Unit)? = null

    fun createTracker(messageReader: CreateTrackerMessageReader, context: Context) {
        val controllers: MutableList<Configuration> = mutableListOf()

        val networkConfigReader = messageReader.networkConfig;
        val networkConfiguration = networkConfigReader.toConfiguration()

        val trackerConfigReader = messageReader.trackerConfig
        if (trackerConfigReader == null) {
            controllers.add(DefaultTrackerConfiguration.toConfiguration(null, context))
        } else {
            controllers.add(trackerConfigReader.toConfiguration(context))
        }

        val subjectConfigReader = messageReader.subjectConfig
        subjectConfigReader?.let { controllers.add(it.toConfiguration()) }

        val gdprConfigReader = messageReader.gdprConfig
        gdprConfigReader?.let { controllers.add(it.toConfiguration()) }

        val emitterConfigReader = messageReader.emitterConfig
        emitterConfigReader?.let { controllers.add(it.toConfiguration()) }

        val globalContextsConfigReader = messageReader.globalContextsConfig
        globalContextsConfigReader?.let { controllers.add(it.toConfiguration()) }

        val sessionConfigReader = messageReader.sessionConfig
        sessionConfigReader?.let { controllers.add(it.toConfiguration()) }

        messageReader.plugins.forEach {
            controllers.add(it.toConfiguration(afterTrackCallback(messageReader.namespace)))
        }

        Snowplow.createTracker(
                context,
                messageReader.namespace,
                networkConfiguration,
                *controllers.toTypedArray()
        )
    }

    fun trackStructured(eventReader: EventMessageReader) {
        val structured = eventReader.toStructuredWithContexts()
        trackEvent(structured, eventReader)
    }

    fun trackSelfDescribing(eventReader: EventMessageReader) {
        val selfDescribing = eventReader.toSelfDescribingWithContexts()
        trackEvent(selfDescribing, eventReader)
    }

    fun trackScreenView(eventReader: EventMessageReader) {
        val screenView = eventReader.toScreenViewWithContexts()
        trackEvent(screenView, eventReader)
    }

    fun trackScrollChanged(eventReader: EventMessageReader) {
        val scroll = eventReader.toScrollChangedWithContexts()
        trackEvent(scroll, eventReader)
    }

    fun trackListItemView(eventReader: EventMessageReader) {
        val listItem = eventReader.toListItemViewWithContexts()
        trackEvent(listItem, eventReader)
    }

    fun trackTiming(eventReader: EventMessageReader) {
        val timing = eventReader.toTimingWithContexts()
        trackEvent(timing, eventReader)
    }

    fun trackConsentGranted(eventReader: EventMessageReader) {
        val consentGranted = eventReader.toConsentGrantedWithContexts()
        trackEvent(consentGranted, eventReader)
    }

    fun trackConsentWithdrawn(eventReader: EventMessageReader) {
        val consentWithdrawn = eventReader.toConsentWithdrawnWithContexts()
        trackEvent(consentWithdrawn, eventReader)
    }

    fun setUserId(messageReader: SetUserIdMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.subject?.userId = messageReader.userId
    }

    fun addGlobalContexts(messageReader: AddGlobalContextsMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        val entity = messageReader.context?.let { SelfDescribingJsonReader(it).toSelfDescribingJson() }
        val staticContexts = listOfNotNull(entity)

        trackerController?.globalContexts?.add(messageReader.tag, GlobalContext(staticContexts))
    }

    fun removeGlobalContexts(messageReader: RemoveGlobalContextsMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.globalContexts?.remove(messageReader.tag)
    }

    fun addPlugin(messageReader: AddPluginMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.plugins?.addPlugin(
            messageReader.plugin.toConfiguration(afterTrackCallback(messageReader.tracker))
        )
    }

    fun removePlugin(messageReader: RemovePluginMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.plugins?.removePlugin(messageReader.identifier)
    }

    private fun afterTrackCallback(namespace: String): (String, InspectableEvent) -> Unit {
        return { identifier, event ->
            afterTrackListener?.invoke(mapOf(
                "tracker" to namespace,
                "plugin" to identifier,
                "event" to mapOf(
                    "schema" to event.schema,
                    "name" to event.name,
                    "payload" to toChannelValue(event.payload),
                    "entities" to event.entities.map { toChannelValue(it.map) }
                )
            ))
        }
    }

    /// Converts the value to types supported by the Flutter standard message codec
    private fun toChannelValue(value: Any?): Any? {
        return when (value) {
            null, is String, is Boolean, is Int, is Long, is Double -> value
            is Number -> value.toDouble()
            is Map<*, *> -> value.entries.associate { it.key.toString() to toChannelValue(it.value) }
            is Collection<*> -> value.map { toChannelValue(it) }
            is Array<*> -> value.map { toChannelValue(it) }
            else -> value.toString()
        }
    }

    fun setUserAnonymisation(messageReader: SetUserAnonymisationMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.userAnonymisation = messageReader.userAnonymisation
    }

    fun setServerAnonymisation(messageReader: SetServerAnonymisationMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.emitter?.serverAnonymisation = messageReader.serverAnonymisation
    }

    fun getSessionUserId(messageReader: GetParameterMessageReader): String? {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.userId
    }

    fun getSessionId(messageReader: GetParameterMessageReader): String? {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.sessionId
    }

    fun getSessionIndex(messageReader: GetParameterMessageReader): Int? {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        return trackerController?.session?.sessionIndex
    }

    fun startNewSession(messageReader: GetParameterMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)

        trackerController?.session?.startNewSession()
    }

    fun startMediaTracking(messageReader: StartMediaTrackingMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)
        trackerController?.media?.startMediaTracking(
            messageReader.configuration.toConfiguration()
        )
    }

    fun endMediaTracking(messageReader: EndMediaTrackingMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)
        trackerController?.media?.endMediaTracking(messageReader.mediaTrackingId)
    }

    fun updateMediaTracking(messageReader: UpdateMediaTrackingMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)
        val mediaTracking = trackerController?.media?.getMediaTracking(messageReader.mediaTrackingId)
        mediaTracking?.update(
            player = messageReader.player?.toMediaPlayerEntity(),
            ad = messageReader.ad?.toMediaAdEntity(),
            adBreak = messageReader.adBreak?.toMediaAdBreakEntity()
        )
    }

    fun trackMediaAdBreakEndEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdBreakEndEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdBreakStartEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdBreakStartEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdClickEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdClickEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdCompleteEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdCompleteEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdFirstQuartileEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdFirstQuartileEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdMidpointEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdMidpointEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdPauseEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdPauseEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdResumeEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdResumeEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdSkipEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdSkipEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdStartEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdStartEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaAdThirdQuartileEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaAdThirdQuartileEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaBufferEndEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaBufferEndEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaBufferStartEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaBufferStartEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaEndEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaEndEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaErrorEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaErrorEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaFullscreenChangeEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaFullscreenChangeEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaPauseEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaPauseEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaPictureInPictureChangeEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaPictureInPictureChangeEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaPlayEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaPlayEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaPlaybackRateChangeEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaPlaybackRateChangeEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaQualityChangeEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaQualityChangeEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaReadyEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaReadyEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaSeekEndEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaSeekEndEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaSeekStartEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaSeekStartEvent()
        trackEvent(event, messageReader)
    }

    fun trackMediaVolumeChangeEvent(messageReader: EventMessageReader) {
        val event = messageReader.toMediaVolumeChangeEvent()
        trackEvent(event, messageReader)
    }

    fun trackWebViewReaderEvent(messageReader: EventMessageReader) {
        val event = messageReader.toWebViewReader()
        trackEvent(event, messageReader)
    }

    fun trackPageView(eventReader: EventMessageReader) {
        val pageView = eventReader.toPageViewWithContexts()
        trackEvent(pageView, eventReader)
    }

    fun trackDeepLinkReceived(eventReader: EventMessageReader) {
        val event = eventReader.toDeepLinkReceivedWithContexts()
        trackEvent(event, eventReader)
    }

    fun trackMessageNotification(eventReader: EventMessageReader) {
        val event = eventReader.toMessageNotificationWithContexts()
        trackEvent(event, eventReader)
    }

    private fun trackEvent(event: Event, messageReader: EventMessageReader) {
        val trackerController = Snowplow.getTracker(messageReader.tracker)
        val mediaTrackingId = messageReader.mediaTrackingId
        if (mediaTrackingId == null) {
            trackerController?.track(event)
        } else {
            val mediaTracking = trackerController?.media?.getMediaTracking(mediaTrackingId)
            mediaTracking?.track(
                event = event,
                player = messageReader.player?.toMediaPlayerEntity(),
                ad = messageReader.ad?.toMediaAdEntity(),
                adBreak = messageReader.adBreak?.toMediaAdBreakEntity()
            )
        }
    }

}
