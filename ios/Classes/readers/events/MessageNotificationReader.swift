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

    func toAttachment() -> MessageNotificationAttachment {
        return MessageNotificationAttachment(identifier: identifier, type: type, url: url)
    }
}

struct MessageNotificationReader: Decodable {
    let title: String
    let body: String
    let trigger: String
    let action: String?
    let attachments: [MessageNotificationAttachmentReader]?
    let categoryIdentifier: String?
    let badge: Int?
    let launchImageName: String?
    let notificationTimestamp: String?
    let sound: String?
    let subtitle: String?
    let thread: String?
}

extension MessageNotificationReader {
    func toMessageNotification() -> MessageNotification {
        let notificationTrigger: MessageNotificationTrigger
        switch trigger {
        case "push": notificationTrigger = .push
        case "location": notificationTrigger = .location
        case "calendar": notificationTrigger = .calendar
        case "timeInterval": notificationTrigger = .timeInterval
        default: notificationTrigger = .other
        }
        let event = MessageNotification(title: title, body: body, trigger: notificationTrigger)
        if let a = action { event.action(a) }
        if let att = attachments { event.attachments(att.map { $0.toAttachment() }) }
        if let ci = categoryIdentifier { event.categoryIdentifier(ci) }
        if let b = badge { event.badge(b) }
        if let li = launchImageName { event.launchImageName(li) }
        if let nt = notificationTimestamp { event.notificationTimestamp(nt) }
        if let s = sound { event.sound(s) }
        if let sub = subtitle { event.subtitle(sub) }
        if let t = thread { event.thread(t) }
        return event
    }
}
