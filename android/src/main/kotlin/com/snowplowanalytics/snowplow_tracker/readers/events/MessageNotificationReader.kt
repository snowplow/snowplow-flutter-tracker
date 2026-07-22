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
    private val trigger: String by values
    val action: String? by valuesDefault
    val badge: Int? by lazy { (values["badge"] as? Number)?.toInt() }
    val categoryIdentifier: String? by valuesDefault
    val launchImageName: String? by valuesDefault
    val notificationTimestamp: String? by valuesDefault
    val sound: String? by valuesDefault
    val subtitle: String? by valuesDefault
    val threadIdentifier: String? by valuesDefault
    private val attachmentsRaw: List<Map<String, Any>>? by valuesDefault
    private val processedAttachments: List<MessageNotificationAttachment>? by lazy {
        attachmentsRaw?.map { map ->
            MessageNotificationAttachment(
                map["identifier"] as String,
                map["type"] as String,
                map["url"] as String
            )
        }
    }

    private fun toTrigger(): MessageNotificationTrigger {
        return when (trigger) {
            "push" -> MessageNotificationTrigger.push
            "calendar" -> MessageNotificationTrigger.calendar
            "timeInterval" -> MessageNotificationTrigger.timeInterval
            "location" -> MessageNotificationTrigger.location
            else -> MessageNotificationTrigger.push
        }
    }

    fun toMessageNotification(): MessageNotification {
        val event = MessageNotification(title, body, toTrigger())
        action?.let { event.action(it) }
        badge?.let { event.badge(it) }
        categoryIdentifier?.let { event.categoryIdentifier(it) }
        launchImageName?.let { event.launchImageName(it) }
        notificationTimestamp?.let { event.notificationTimestamp(it) }
        sound?.let { event.sound(it) }
        subtitle?.let { event.subtitle(it) }
        threadIdentifier?.let { event.thread(it) }
        processedAttachments?.let { event.attachments(it) }
        return event
    }
}
