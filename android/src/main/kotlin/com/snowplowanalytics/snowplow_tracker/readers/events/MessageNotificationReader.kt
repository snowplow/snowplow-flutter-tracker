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
    val notificationTimestamp: String? by valuesDefault
    val categoryIdentifier: String? by valuesDefault
    val threadIdentifier: String? by valuesDefault
    val subtitle: String? by valuesDefault
    val badge: Int? by lazy { (values["badge"] as? Number)?.toInt() }
    val sound: String? by valuesDefault
    val launchImageName: String? by valuesDefault
    val action: String? by valuesDefault

    @Suppress("UNCHECKED_CAST")
    val attachments: List<MessageNotificationAttachment>? by lazy {
        (values["attachments"] as? List<*>)?.filterIsInstance<Map<String, Any>>()?.map {
            MessageNotificationAttachment(
                it["identifier"] as String,
                it["type"] as String,
                it["url"] as String
            )
        }
    }

    fun toMessageNotification(): MessageNotification {
        val triggerEnum = when (trigger) {
            "push" -> MessageNotificationTrigger.push
            "location" -> MessageNotificationTrigger.location
            "calendar" -> MessageNotificationTrigger.calendar
            "timeInterval" -> MessageNotificationTrigger.timeInterval
            else -> MessageNotificationTrigger.push
        }
        val event = MessageNotification(title, body, triggerEnum)
        notificationTimestamp?.let { event.notificationTimestamp(it) }
        categoryIdentifier?.let { event.categoryIdentifier(it) }
        threadIdentifier?.let { event.threadIdentifier(it) }
        subtitle?.let { event.subtitle(it) }
        badge?.let { event.badge(it) }
        sound?.let { event.sound(it) }
        launchImageName?.let { event.launchImageName(it) }
        action?.let { event.action(it) }
        attachments?.let { event.attachments(it) }
        return event
    }
}
