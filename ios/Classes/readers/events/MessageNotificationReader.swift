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
    private var nativeTrigger: MessageNotificationTrigger {
        switch trigger {
        case "push": return .push
        case "location": return .location
        case "calendar": return .calendar
        case "timeInterval": return .timeInterval
        default: return .other
        }
    }

    func toMessageNotification() -> MessageNotification {
        let event = MessageNotification(title: title, body: body, trigger: nativeTrigger)
        if let a = action { event.action(a) }
        if let a = attachments { event.attachments(a.map { $0.toAttachment() }) }
        if let a = bodyLocArgs { event.bodyLocArgs(a) }
        if let a = bodyLocKey { event.bodyLocKey(a) }
        if let a = category { event.category(a) }
        if let a = contentAvailable { event.contentAvailable(a) }
        if let a = group { event.group(a) }
        if let a = icon { event.icon(a) }
        if let a = notificationCount { event.notificationCount(a) }
        if let a = notificationTimestamp { event.notificationTimestamp(a) }
        if let a = sound { event.sound(a) }
        if let a = subtitle { event.subtitle(a) }
        if let a = tag { event.tag(a) }
        if let a = threadIdentifier { event.threadIdentifier(a) }
        if let a = titleLocArgs { event.titleLocArgs(a) }
        if let a = titleLocKey { event.titleLocKey(a) }
        return event
    }
}
