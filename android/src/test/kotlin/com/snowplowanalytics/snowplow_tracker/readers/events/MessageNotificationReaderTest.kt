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
    fun `reader extracts required fields`() {
        val map = mapOf(
            "title" to "Test Title",
            "body" to "Test Body",
            "trigger" to "push"
        )
        val reader = MessageNotificationReader(map)

        assertEquals("Test Title", reader.title)
        assertEquals("Test Body", reader.body)
    }

    @Test
    fun `reader extracts optional fields`() {
        val map = mapOf(
            "title" to "Title",
            "body" to "Body",
            "trigger" to "calendar",
            "action" to "Open",
            "badge" to 3,
            "categoryIdentifier" to "cat1",
            "launchImageName" to "launch",
            "notificationTimestamp" to "2023-01-01T00:00:00Z",
            "sound" to "default",
            "subtitle" to "Subtitle",
            "threadIdentifier" to "thread1"
        )
        val reader = MessageNotificationReader(map)

        assertEquals("Open", reader.action)
        assertEquals(3, reader.badge)
        assertEquals("cat1", reader.categoryIdentifier)
        assertEquals("launch", reader.launchImageName)
        assertEquals("2023-01-01T00:00:00Z", reader.notificationTimestamp)
        assertEquals("default", reader.sound)
        assertEquals("Subtitle", reader.subtitle)
        assertEquals("thread1", reader.threadIdentifier)
    }

    @Test
    fun `reader nulls optional fields when absent`() {
        val map = mapOf(
            "title" to "Title",
            "body" to "Body",
            "trigger" to "push"
        )
        val reader = MessageNotificationReader(map)

        assertNull(reader.action)
        assertNull(reader.badge)
        assertNull(reader.categoryIdentifier)
        assertNull(reader.launchImageName)
        assertNull(reader.notificationTimestamp)
        assertNull(reader.sound)
        assertNull(reader.subtitle)
        assertNull(reader.threadIdentifier)
    }

    @Test
    fun `toMessageNotification produces event with required fields`() {
        val map = mapOf(
            "title" to "Title",
            "body" to "Body",
            "trigger" to "push"
        )
        val reader = MessageNotificationReader(map)
        val event = reader.toMessageNotification()

        assertNotNull(event)
    }

    @Test
    fun `toMessageNotification produces event with all optional fields`() {
        val attachmentMap = mapOf(
            "identifier" to "att1",
            "type" to "image/png",
            "url" to "https://example.com/image.png"
        )
        val map = mapOf(
            "title" to "Title",
            "body" to "Body",
            "trigger" to "timeInterval",
            "action" to "Open",
            "badge" to 2,
            "categoryIdentifier" to "cat1",
            "launchImageName" to "launch",
            "notificationTimestamp" to "2023-01-01T00:00:00Z",
            "sound" to "default",
            "subtitle" to "Subtitle",
            "threadIdentifier" to "thread1",
            "attachments" to listOf(attachmentMap)
        )
        val reader = MessageNotificationReader(map)
        val event = reader.toMessageNotification()

        assertNotNull(event)
    }

    @Test
    fun `reader handles all trigger values`() {
        listOf("push", "calendar", "timeInterval", "location").forEach { triggerStr ->
            val map = mapOf(
                "title" to "Title",
                "body" to "Body",
                "trigger" to triggerStr
            )
            val reader = MessageNotificationReader(map)
            val event = reader.toMessageNotification()
            assertNotNull("Event should not be null for trigger: $triggerStr", event)
        }
    }
}
