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

package com.snowplowanalytics.snowplow_tracker

import android.content.Context

import com.snowplowanalytics.snowplow.Snowplow;
import com.snowplowanalytics.snowplow.configuration.Configuration;
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

        Snowplow.createTracker(
                context,
                messageReader.namespace,
                networkConfiguration,
                *controllers.toTypedArray()
        )
    }

    fun trackStructured(eventReader: EventMessageReader) {
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val structured = eventReader.toStructuredWithContexts()

        trackerController?.track(structured)
    }

    fun trackSelfDescribing(eventReader: EventMessageReader) {
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val selfDescribing = eventReader.toSelfDescribingWithContexts()

        trackerController?.track(selfDescribing)
    }

    fun trackScreenView(eventReader: EventMessageReader) {
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val screenView = eventReader.toScreenViewWithContexts()

        trackerController?.track(screenView)
    }

    fun trackTiming(eventReader: EventMessageReader) {
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val timing = eventReader.toTimingWithContexts()

        trackerController?.track(timing)
    }

    fun trackConsentGranted(eventReader: EventMessageReader) {
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val consentGranted = eventReader.toConsentGrantedWithContexts()

        trackerController?.track(consentGranted)
    }

    fun trackConsentWithdrawn(eventReader: EventMessageReader) {
        val trackerController = Snowplow.getTracker(eventReader.tracker)
        val consentWithdrawn = eventReader.toConsentWithdrawnWithContexts()

        trackerController?.track(consentWithdrawn)
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

}
