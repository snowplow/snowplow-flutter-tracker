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

import com.snowplowanalytics.snowplow.Snowplow;
import com.snowplowanalytics.snowplow.configuration.Configuration;
import com.snowplowanalytics.snowplow.event.Event
import com.snowplowanalytics.snowplow_tracker.readers.configurations.DefaultTrackerConfiguration
import com.snowplowanalytics.snowplow_tracker.readers.messages.*

object SnowplowTrackerController {

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
