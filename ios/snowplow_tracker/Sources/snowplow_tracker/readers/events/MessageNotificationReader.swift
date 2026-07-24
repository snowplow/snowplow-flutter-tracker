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

struct MessageNotificationReader: Decodable {
    let title: String
    let body: String
    let trigger: String
    let action: String?
    let attachments: [MessageNotificationAttachmentReader]?
    let bodyLocArgs: [String]?
    let bodyLocKey: String?
    let category: String?
    let contentAvailable: Bool?
    let group: String?
    let icon: String?
    let notificationCount: Int?
    let notificationTimestamp: String?
    let sound: String?
    let subtitle: String?
    let tag: String?
    let threadIdentifier: String?
    let titleLocArgs: [String]?
    let titleLocKey: String?
}

extension MessageNotificationReader {
    func toMessageNotification() -> MessageNotification {
        let nativeTrigger: MessageNotificationTrigger
        switch trigger {
        case "push": nativeTrigger = .push
        case "location": nativeTrigger = .location
        case "calendar": nativeTrigger = .calendar
        case "timeInterval": nativeTrigger = .timeInterval
        default: nativeTrigger = .other
        }

        let event = MessageNotification(title: title, body: body, trigger: nativeTrigger)
        if let action = self.action { event.action(action) }
        if let attachments = self.attachments { event.attachments(attachments.map { $0.toAttachment() }) }
        if let bodyLocArgs = self.bodyLocArgs { event.bodyLocArgs(bodyLocArgs) }
        if let bodyLocKey = self.bodyLocKey { event.bodyLocKey(bodyLocKey) }
        if let category = self.category { event.category(category) }
        if let contentAvailable = self.contentAvailable { event.contentAvailable(contentAvailable) }
        if let group = self.group { event.group(group) }
        if let icon = self.icon { event.icon(icon) }
        if let notificationCount = self.notificationCount { event.notificationCount(notificationCount) }
        if let notificationTimestamp = self.notificationTimestamp { event.notificationTimestamp(notificationTimestamp) }
        if let sound = self.sound { event.sound(sound) }
        if let subtitle = self.subtitle { event.subtitle(subtitle) }
        if let tag = self.tag { event.tag(tag) }
        if let threadIdentifier = self.threadIdentifier { event.threadIdentifier(threadIdentifier) }
        if let titleLocArgs = self.titleLocArgs { event.titleLocArgs(titleLocArgs) }
        if let titleLocKey = self.titleLocKey { event.titleLocKey(titleLocKey) }
        return event
    }
}
