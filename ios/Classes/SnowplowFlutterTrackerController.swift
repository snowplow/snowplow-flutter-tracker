//
//  SnowplowFlutterTrackerController.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 03/01/2022.
//

import Foundation
import SnowplowTracker

class SnowplowFlutterTrackerController {
    static func createTracker(_ message: CreateTrackerMessageReader, arguments: [String: Any]) {
        var controllers: [Configuration] = []
        
        if let trackerConfig = message.trackerConfig {
            controllers.append(trackerConfig.toConfiguration())
        }
        if let subjectConfig = message.subjectConfig {
            controllers.append(subjectConfig.toConfiguration())
        }
        if let gdprConfig = message.gdprConfig {
            controllers.append(gdprConfig.toConfiguration())
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
