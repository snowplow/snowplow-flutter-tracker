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

package com.snowplowanalytics.snowplow_tracker.readers.events

import com.snowplowanalytics.snowplow.event.MessageNotification
import com.snowplowanalytics.snowplow.event.MessageNotificationAttachment
import com.snowplowanalytics.snowplow.event.MessageNotificationTrigger

class MessageNotificationReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val title: String by values
    val body: String by values
    val trigger: String by values
    val action: String? by valuesDefault
    val categoryIdentifier: String? by valuesDefault
    val badge: Int? by lazy { (values["badge"] as? Number)?.toInt() }
    val launchImageName: String? by valuesDefault
    val notificationTimestamp: String? by valuesDefault
    val sound: String? by valuesDefault
    val subtitle: String? by valuesDefault
    val thread: String? by valuesDefault
    private val attachmentMaps: List<Map<String, Any>>? by valuesDefault
    val attachments: List<MessageNotificationAttachment>? by lazy {
        attachmentMaps?.map { map ->
            MessageNotificationAttachment(
                identifier = map["identifier"] as String,
                type = map["type"] as String,
                url = map["url"] as String
            )
        }
    }

    fun toMessageNotification(): MessageNotification {
        val notificationTrigger = when (trigger) {
            "push" -> MessageNotificationTrigger.push
            "location" -> MessageNotificationTrigger.location
            "calendar" -> MessageNotificationTrigger.calendar
            "timeInterval" -> MessageNotificationTrigger.timeInterval
            else -> MessageNotificationTrigger.other
        }
        val event = MessageNotification(title, body, notificationTrigger)
        action?.let { event.action(it) }
        attachments?.let { event.attachments(it) }
        categoryIdentifier?.let { event.categoryIdentifier(it) }
        badge?.let { event.badge(it) }
        launchImageName?.let { event.launchImageName(it) }
        notificationTimestamp?.let { event.notificationTimestamp(it) }
        sound?.let { event.sound(it) }
        subtitle?.let { event.subtitle(it) }
        thread?.let { event.thread(it) }
        return event
    }
}
