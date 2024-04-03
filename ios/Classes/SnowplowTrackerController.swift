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

import Foundation
import SnowplowTracker

class SnowplowTrackerController {
    // TODO: remove after 6.0.2 release of iOS tracker is published
    private static var mediaTrackings: [String: MediaTracking] = [:]

    static func createTracker(_ message: CreateTrackerMessageReader, arguments: [String: Any]) {
        var controllers: [ConfigurationProtocol] = []
        
        if let trackerConfig = message.trackerConfig {
            controllers.append(trackerConfig.toConfiguration())
        } else {
            controllers.append(TrackerConfigurationReader.defaultConfiguration())
        }
        if let subjectConfig = message.subjectConfig {
            controllers.append(subjectConfig.toConfiguration())
        }
        if let gdprConfig = message.gdprConfig {
            controllers.append(gdprConfig.toConfiguration())
        }
        if let emitterConfig = message.emitterConfig {
            controllers.append(emitterConfig.toConfiguration())
        }
        
        Snowplow.createTracker(
            namespace: message.namespace,
            network: message.networkConfig.toConfiguration(),
            configurations: controllers
        )
    }
    
    static func trackStructured(_ message: TrackStructuredMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toStructured()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }
    
    static func trackSelfDescribing(_ message: TrackSelfDescribingMesssageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        if let event = message.toSelfDescribing(arguments: arguments) {
            trackEvent(event, eventMessage: eventMessage, arguments: arguments)
        }
    }
    
    static func trackScreenView(_ message: TrackScreenViewMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toScreenView()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }
    
    static func trackScrollChanged(_ message: TrackScrollChangedMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toScrollChanged()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }
    
    static func trackListItemView(_ message: TrackListItemViewMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toListItemView()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }
    
    static func trackTiming(_ message: TrackTimingMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toTiming()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }
    
    static func trackConsentGranted(_ message: TrackConsentGrantedMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toConsentGranted()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }
    
    static func trackConsentWithdrawn(_ message: TrackConsentWithdrawnMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toConsentWithdrawn()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }
    
    static func sessionUserId(_ message: GetParameterMessageReader) -> String? {
        return Snowplow.tracker(namespace: message.tracker)?.session?.userId
    }
    
    static func sessionId(_ message: GetParameterMessageReader) -> String? {
        return Snowplow.tracker(namespace: message.tracker)?.session?.sessionId
    }
    
    static func sessionIndex(_ message: GetParameterMessageReader) -> Int? {
        return Snowplow.tracker(namespace: message.tracker)?.session?.sessionIndex
    }
    
    static func setUserId(_ message: SetUserIdMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.userId = message.userId
    }

    static func startMediaTracking(_ message: StartMediaTrackingMessageReader, arguments: [String: Any]) {
        let configurationArguments = arguments["configuration"] as? [String: Any] ?? [:]
        let mediaTrackingConfiguration = message.configuration.toMediaTrackingConfiguration(arguments: configurationArguments)
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        let mediaTracking = trackerController?.media.startMediaTracking(configuration: mediaTrackingConfiguration)
        self.mediaTrackings[mediaTrackingConfiguration.id] = mediaTracking
    }

    static func endMediaTracking(_ message: EndMediaTrackingMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.media.endMediaTracking(id: message.mediaTrackingId)
        self.mediaTrackings.removeValue(forKey: message.mediaTrackingId)
    }

    static func updateMediaTracking(_ message: UpdateMediaTrackingMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        if let media = self.mediaTrackings[message.mediaTrackingId] {
            media.update(
                player: message.player?.toMediaPlayerEntity(),
                ad: message.ad?.toMediaAdEntity(),
                adBreak: message.adBreak?.toMediaAdBreakEntity()
            )
        }
    }
    static func trackMediaAdBreakEndEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdBreakEndEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdBreakStartEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdBreakStartEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdClickEvent(eventMessage: TrackMediaAdEventMessageReader, arguments: [String: Any]) {
        let event = MediaAdClickEvent(percentProgress: message.eventData.percentProgress)
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdCompleteEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdCompleteEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdFirstQuartileEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdFirstQuartileEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdMidpointEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdMidpointEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdPauseEvent(_ message: TrackMediaAdEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdPauseEvent(percentProgress: message.eventData.percentProgress)
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdResumeEvent(_ message: TrackMediaAdEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdResumeEvent(percentProgress: message.eventData.percentProgress)
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdSkipEvent(_ message: TrackMediaAdEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdSkipEvent(percentProgress: message.eventData.percentProgress)
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdStartEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdStartEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaAdThirdQuartileEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaAdThirdQuartileEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaBufferEndEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaBufferEndEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaBufferStartEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaBufferStartEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaEndEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaEndEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaErrorEvent(_ message: TrackMediaErrorEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toMediaErrorEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaFullscreenChangeEvent(_ message: TrackMediaFullscreenChangeEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toMediaFullscreenChangeEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaPauseEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaPauseEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaPictureInPictureChangeEvent(_ message: TrackMediaPictureInPictureChangeEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toMediaPictureInPictureChangeEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaPlayEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaPlayEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    // static func trackMediaPlaybackRateChangeEvent(_ message: TrackMediaPlaybackRateChangeEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
    //     let event = message.toMediaPlaybackRateChangeEvent()
    //     trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    // }

    static func trackMediaQualityChangeEvent(_ message: TrackMediaQualityChangeEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toMediaQualityChangeEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaReadyEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaReadyEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaSeekEndEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaSeekEndEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaSeekStartEvent(eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = MediaSeekStartEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    static func trackMediaVolumeChangeEvent(_ message: TrackMediaVolumeChangeEventMessageReader, eventMessage: EventMessageReader, arguments: [String: Any]) {
        let event = message.toMediaVolumeChangeEvent()
        trackEvent(event, eventMessage: eventMessage, arguments: arguments)
    }

    private static func trackEvent(_ event: Event, eventMessage: EventMessageReader, arguments: [String: Any]) {
        eventMessage.addContextsToEvent(event, arguments: arguments)
        let trackerController = Snowplow.tracker(namespace: eventMessage.tracker)
        if let mediaTrackingId = eventMessage.mediaTrackingId {
            if let media = self.mediaTrackings[mediaTrackingId] {
                media.track(
                    event,
                    player: eventMessage.player?.toMediaPlayerEntity(),
                    ad: eventMessage.ad?.toMediaAdEntity(),
                    adBreak: eventMessage.adBreak?.toMediaAdBreakEntity()
                )
            }
        } else {
            trackerController?.track(event)
        }
    }
}
