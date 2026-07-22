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
    let badge: Int?
    let categoryIdentifier: String?
    let launchImageName: String?
    let notificationTimestamp: String?
    let sound: String?
    let subtitle: String?
    let threadIdentifier: String?
    let attachments: [MessageNotificationAttachmentReader]?

    private func toTrigger() -> MessageNotificationTrigger {
        switch trigger {
        case "push": return .push
        case "calendar": return .calendar
        case "timeInterval": return .timeInterval
        case "location": return .location
        default: return .push
        }
    }
}

extension MessageNotificationReader {
    func toMessageNotification() -> MessageNotification {
        let event = MessageNotification(title: title, body: body, trigger: toTrigger())
        if let a = self.action { event.action(a) }
        if let b = self.badge { event.badge(b) }
        if let ci = self.categoryIdentifier { event.categoryIdentifier(ci) }
        if let li = self.launchImageName { event.launchImageName(li) }
        if let nt = self.notificationTimestamp { event.notificationTimestamp(nt) }
        if let s = self.sound { event.sound(s) }
        if let st = self.subtitle { event.subtitle(st) }
        if let ti = self.threadIdentifier { event.thread(ti) }
        if let att = self.attachments {
            event.attachments(att.map { $0.toAttachment() })
        }
        return event
    }
}
