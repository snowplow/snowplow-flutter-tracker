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
import com.snowplowanalytics.snowplow.event.MessageNotificationTrigger

class MessageNotificationReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val title: String by values
    val body: String by values
    private val trigger: String by values
    val action: String? by valuesDefault
    val bodyLocKey: String? by valuesDefault
    val category: String? by valuesDefault
    val contentAvailable: Boolean? by valuesDefault
    val group: String? by valuesDefault
    val icon: String? by valuesDefault
    val notificationTimestamp: String? by valuesDefault
    val sound: String? by valuesDefault
    val subtitle: String? by valuesDefault
    val tag: String? by valuesDefault
    val threadIdentifier: String? by valuesDefault
    val titleLocKey: String? by valuesDefault

    val notificationCount: Int? by lazy {
        (values["notificationCount"] as? Number)?.toInt()
    }

    val bodyLocArgs: List<String>? by lazy {
        (values["bodyLocArgs"] as? List<*>)?.filterIsInstance<String>()
    }

    val titleLocArgs: List<String>? by lazy {
        (values["titleLocArgs"] as? List<*>)?.filterIsInstance<String>()
    }

    val attachments: List<MessageNotificationAttachmentReader>? by lazy {
        (values["attachments"] as? List<*>)
            ?.filterIsInstance<Map<String, Any>>()
            ?.map { MessageNotificationAttachmentReader(it) }
    }

    val nativeTrigger: MessageNotificationTrigger by lazy {
        MessageNotificationTrigger.values().firstOrNull { it.name == trigger }
            ?: MessageNotificationTrigger.other
    }

    fun toMessageNotification(): MessageNotification {
        val event = MessageNotification(title, body, nativeTrigger)
        action?.let { event.action(it) }
        attachments?.let { event.attachments(it.map { a -> a.toAttachment() }) }
        bodyLocArgs?.let { event.bodyLocArgs(it) }
        bodyLocKey?.let { event.bodyLocKey(it) }
        category?.let { event.category(it) }
        contentAvailable?.let { event.contentAvailable(it) }
        group?.let { event.group(it) }
        icon?.let { event.icon(it) }
        notificationCount?.let { event.notificationCount(it) }
        notificationTimestamp?.let { event.notificationTimestamp(it) }
        sound?.let { event.sound(it) }
        subtitle?.let { event.subtitle(it) }
        tag?.let { event.tag(it) }
        threadIdentifier?.let { event.threadIdentifier(it) }
        titleLocArgs?.let { event.titleLocArgs(it) }
        titleLocKey?.let { event.titleLocKey(it) }
        return event
    }
}
