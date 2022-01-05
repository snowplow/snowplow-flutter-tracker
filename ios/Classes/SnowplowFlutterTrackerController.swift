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
        if let sessionConfig = message.sessionConfig {
            controllers.append(sessionConfig.toConfiguration())
        }
        if let emitterConfig = message.emitterConfig {
            controllers.append(emitterConfig.toConfiguration())
        }
        if let subjectConfig = message.subjectConfig {
            controllers.append(subjectConfig.toConfiguration())
        }
        if let gdprConfig = message.gdprConfig {
            controllers.append(gdprConfig.toConfiguration())
        }
        if let gcConfig = message.toGlobalContextsConfiguration(arguments: arguments) {
            controllers.append(gcConfig)
        }
        
        Snowplow.createTracker(
            namespace: message.namespace,
            network: message.networkConfig.toConfiguration(),
            configurations: controllers
        )
    }
    
    static func removeTracker(_ message: RemoveTrackerMessageReader) {
        if let trackerController = Snowplow.tracker(namespace: message.tracker) {
            Snowplow.remove(tracker: trackerController)
        }
    }
    
    static func removeAllTrackers() {
        Snowplow.removeAllTrackers()
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
    
    static func isInBackground(_ message: GetParameterMessageReader) -> Bool? {
        return Snowplow.tracker(namespace: message.tracker)?.session?.isInBackground
    }
    
    static func backgroundIndex(_ message: GetParameterMessageReader) -> Int? {
        return Snowplow.tracker(namespace: message.tracker)?.session?.backgroundIndex
    }
    
    static func foregroundIndex(_ message: GetParameterMessageReader) -> Int? {
        return Snowplow.tracker(namespace: message.tracker)?.session?.foregroundIndex
    }
    
    static func setUserId(_ message: SetUserIdMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.userId = message.userId
    }
    
    static func setNetworkUserId(_ message: SetNetworkUserIdMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.networkUserId = message.networkUserId
    }
    
    static func setDomainUserId(_ message: SetDomainUserIdMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.domainUserId = message.domainUserId
    }
    
    static func setIpAddress(_ message: SetIpAddressMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.ipAddress = message.ipAddress
    }
    
    static func setUseragent(_ message: SetUseragentMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.useragent = message.useragent
    }
    
    static func setTimezone(_ message: SetTimezoneMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.timezone = message.timezone
    }
    
    static func setLanguage(_ message: SetLanguageMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.language = message.language
    }
    
    static func setScreenResolution(_ message: SetScreenResolutionMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.screenResolution = message.screenResolutionSize
    }
    
    static func setScreenViewport(_ message: SetScreenViewportMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.screenViewPort = message.screenViewportSize
    }
    
    static func setColorDepth(_ message: SetColorDepthMessageReader) {
        let trackerController = Snowplow.tracker(namespace: message.tracker)
        trackerController?.subject?.colorDepth = message.colorDepthNumber
    }
    
    private static func trackEvent(_ event: Event, eventMessage: EventMessageReader, arguments: [String: Any]) {
        eventMessage.addContextsToEvent(event, arguments: arguments)
        let trackerController = Snowplow.tracker(namespace: eventMessage.tracker)
        trackerController?.track(event)
    }
}
