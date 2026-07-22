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
        event.action = action
        event.attachments = attachments?.map { $0.toAttachment() }
        event.bodyLocArgs = bodyLocArgs
        event.bodyLocKey = bodyLocKey
        event.category = category
        event.contentAvailable = contentAvailable
        event.group = group
        event.icon = icon
        event.notificationCount = notificationCount
        event.notificationTimestamp = notificationTimestamp
        event.sound = sound
        event.subtitle = subtitle
        event.tag = tag
        event.threadIdentifier = threadIdentifier
        event.titleLocArgs = titleLocArgs
        event.titleLocKey = titleLocKey
        return event
    }
}
