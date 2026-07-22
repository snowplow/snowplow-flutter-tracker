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
            "bodyLocArgs" to listOf("bodyArg"),
            "bodyLocKey" to "bodyKey",
            "category" to "cat1",
            "contentAvailable" to true,
            "group" to "group1",
            "icon" to "icon1",
            "notificationCount" to 5,
            "notificationTimestamp" to "2023-01-01T00:00:00Z",
            "sound" to "default",
            "subtitle" to "Subtitle",
            "tag" to "tag1",
            "threadIdentifier" to "thread1",
            "titleLocArgs" to listOf("titleArg"),
            "titleLocKey" to "titleKey"
        )
        val reader = MessageNotificationReader(map)

        assertEquals("Open", reader.action)
        assertEquals(listOf("bodyArg"), reader.bodyLocArgs)
        assertEquals("bodyKey", reader.bodyLocKey)
        assertEquals("cat1", reader.category)
        assertEquals(true, reader.contentAvailable)
        assertEquals("group1", reader.group)
        assertEquals("icon1", reader.icon)
        assertEquals(5, reader.notificationCount)
        assertEquals("2023-01-01T00:00:00Z", reader.notificationTimestamp)
        assertEquals("default", reader.sound)
        assertEquals("Subtitle", reader.subtitle)
        assertEquals("tag1", reader.tag)
        assertEquals("thread1", reader.threadIdentifier)
        assertEquals(listOf("titleArg"), reader.titleLocArgs)
        assertEquals("titleKey", reader.titleLocKey)
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
        assertNull(reader.bodyLocArgs)
        assertNull(reader.bodyLocKey)
        assertNull(reader.category)
        assertNull(reader.contentAvailable)
        assertNull(reader.group)
        assertNull(reader.icon)
        assertNull(reader.notificationCount)
        assertNull(reader.notificationTimestamp)
        assertNull(reader.sound)
        assertNull(reader.subtitle)
        assertNull(reader.tag)
        assertNull(reader.threadIdentifier)
        assertNull(reader.titleLocArgs)
        assertNull(reader.titleLocKey)
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
            "category" to "cat1",
            "notificationCount" to 2,
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
