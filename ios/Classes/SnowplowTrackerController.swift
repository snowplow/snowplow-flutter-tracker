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

import Foundation
import SnowplowTracker

class SnowplowTrackerController {
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
    
    private static func trackEvent(_ event: Event, eventMessage: EventMessageReader, arguments: [String: Any]) {
        eventMessage.addContextsToEvent(event, arguments: arguments)
        let trackerController = Snowplow.tracker(namespace: eventMessage.tracker)
        trackerController?.track(event)
    }
}
