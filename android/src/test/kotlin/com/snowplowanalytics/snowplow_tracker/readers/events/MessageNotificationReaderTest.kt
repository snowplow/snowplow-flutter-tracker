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

import org.junit.Assert.*
import org.junit.Test

class MessageNotificationReaderTest {

    @Test
    fun `reads required fields`() {
        val map = mapOf<String, Any>(
            "title" to "My Title",
            "body" to "My Body",
            "trigger" to "push"
        )
        val reader = MessageNotificationReader(map)
        assertEquals("My Title", reader.title)
        assertEquals("My Body", reader.body)
        assertEquals("push", reader.trigger)
    }

    @Test
    fun `optional fields are null when not provided`() {
        val map = mapOf<String, Any>(
            "title" to "T",
            "body" to "B",
            "trigger" to "push"
        )
        val reader = MessageNotificationReader(map)
        assertNull(reader.action)
        assertNull(reader.categoryIdentifier)
        assertNull(reader.badge)
        assertNull(reader.launchImageName)
        assertNull(reader.notificationTimestamp)
        assertNull(reader.sound)
        assertNull(reader.subtitle)
        assertNull(reader.thread)
        assertNull(reader.attachments)
    }

    @Test
    fun `reads all optional fields`() {
        val attachmentMap = mapOf<String, Any>(
            "identifier" to "att1",
            "type" to "image/png",
            "url" to "https://example.com/img.png"
        )
        val map = mapOf<String, Any>(
            "title" to "Title",
            "body" to "Body",
            "trigger" to "calendar",
            "action" to "Open",
            "attachments" to listOf(attachmentMap),
            "categoryIdentifier" to "cat1",
            "badge" to 3,
            "launchImageName" to "launch",
            "notificationTimestamp" to "2021-01-01T00:00:00.000Z",
            "sound" to "default",
            "subtitle" to "Sub",
            "thread" to "thread1"
        )
        val reader = MessageNotificationReader(map)
        assertEquals("Open", reader.action)
        assertEquals("cat1", reader.categoryIdentifier)
        assertEquals(3, reader.badge)
        assertEquals("launch", reader.launchImageName)
        assertEquals("2021-01-01T00:00:00.000Z", reader.notificationTimestamp)
        assertEquals("default", reader.sound)
        assertEquals("Sub", reader.subtitle)
        assertEquals("thread1", reader.thread)
        assertEquals(1, reader.attachments?.size)
        assertEquals("att1", reader.attachments?.get(0)?.identifier)
        assertEquals("image/png", reader.attachments?.get(0)?.type)
        assertEquals("https://example.com/img.png", reader.attachments?.get(0)?.url)
    }

    @Test
    fun `toMessageNotification creates event for push trigger`() {
        val map = mapOf<String, Any>(
            "title" to "T",
            "body" to "B",
            "trigger" to "push"
        )
        val event = MessageNotificationReader(map).toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun `toMessageNotification creates event for location trigger`() {
        val map = mapOf<String, Any>(
            "title" to "T",
            "body" to "B",
            "trigger" to "location"
        )
        val event = MessageNotificationReader(map).toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun `toMessageNotification creates event for calendar trigger`() {
        val map = mapOf<String, Any>(
            "title" to "T",
            "body" to "B",
            "trigger" to "calendar"
        )
        val event = MessageNotificationReader(map).toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun `toMessageNotification creates event for timeInterval trigger`() {
        val map = mapOf<String, Any>(
            "title" to "T",
            "body" to "B",
            "trigger" to "timeInterval"
        )
        val event = MessageNotificationReader(map).toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun `toMessageNotification creates event for other trigger`() {
        val map = mapOf<String, Any>(
            "title" to "T",
            "body" to "B",
            "trigger" to "other"
        )
        val event = MessageNotificationReader(map).toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun `toMessageNotification falls back to other for unknown trigger`() {
        val map = mapOf<String, Any>(
            "title" to "T",
            "body" to "B",
            "trigger" to "unknownTriggerValue"
        )
        val event = MessageNotificationReader(map).toMessageNotification()
        assertNotNull(event)
    }
}
