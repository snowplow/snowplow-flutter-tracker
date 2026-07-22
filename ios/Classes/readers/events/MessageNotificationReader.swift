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

struct MessageNotificationAttachmentReader: Decodable {
    let identifier: String
    let type: String
    let url: String
}

struct MessageNotificationReader: Decodable {
    let title: String
    let body: String
    let trigger: String
    let notificationTimestamp: String?
    let categoryIdentifier: String?
    let threadIdentifier: String?
    let subtitle: String?
    let badge: Int?
    let sound: String?
    let launchImageName: String?
    let action: String?
    let attachments: [MessageNotificationAttachmentReader]?
}

extension MessageNotificationReader {
    func toMessageNotification() -> MessageNotification {
        let triggerEnum: MessageNotificationTrigger
        switch trigger {
        case "push": triggerEnum = .push
        case "location": triggerEnum = .location
        case "calendar": triggerEnum = .calendar
        case "timeInterval": triggerEnum = .timeInterval
        default: triggerEnum = .push
        }
        let event = MessageNotification(title: title, body: body, trigger: triggerEnum)
        if let ts = notificationTimestamp { event.notificationTimestamp(ts) }
        if let ci = categoryIdentifier { event.categoryIdentifier(ci) }
        if let ti = threadIdentifier { event.thread(ti) }
        if let s = subtitle { event.subtitle(s) }
        if let b = badge { event.badge(b) }
        if let s = sound { event.sound(s) }
        if let lim = launchImageName { event.launchImageName(lim) }
        if let a = action { event.action(a) }
        if let atts = attachments {
            let native = atts.map {
                MessageNotificationAttachment(identifier: $0.identifier, type: $0.type, url: $0.url)
            }
            event.attachments(native)
        }
        return event
    }
}
