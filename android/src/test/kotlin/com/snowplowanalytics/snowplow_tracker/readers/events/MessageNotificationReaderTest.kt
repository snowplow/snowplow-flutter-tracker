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
import org.junit.Test
import org.junit.Assert.*

class MessageNotificationReaderTest {

    private val minimalMap = mapOf(
        "title" to "Test Title",
        "body" to "Test body",
        "trigger" to "push"
    )

    @Test
    fun readsRequiredFields() {
        val reader = MessageNotificationReader(minimalMap)
        assertEquals("Test Title", reader.title)
        assertEquals("Test body", reader.body)
        assertEquals("push", reader.trigger)
    }

    @Test
    fun optionalFieldsAreNullByDefault() {
        val reader = MessageNotificationReader(minimalMap)
        assertNull(reader.notificationTimestamp)
        assertNull(reader.categoryIdentifier)
        assertNull(reader.threadIdentifier)
        assertNull(reader.subtitle)
        assertNull(reader.badge)
        assertNull(reader.sound)
        assertNull(reader.launchImageName)
        assertNull(reader.action)
        assertNull(reader.attachments)
    }

    @Test
    fun readsBadgeAsInt() {
        val map = minimalMap + mapOf("badge" to 5)
        val reader = MessageNotificationReader(map)
        assertEquals(5, reader.badge)
    }

    @Test
    fun readsBadgeFromLong() {
        val map = minimalMap + mapOf("badge" to 3L)
        val reader = MessageNotificationReader(map)
        assertEquals(3, reader.badge)
    }

    @Test
    fun readsAllOptionalStringFields() {
        val map = minimalMap + mapOf(
            "notificationTimestamp" to "2023-01-01T00:00:00.000Z",
            "categoryIdentifier" to "cat1",
            "threadIdentifier" to "thread1",
            "subtitle" to "subtitle text",
            "sound" to "sound.wav",
            "launchImageName" to "launch.png",
            "action" to "click"
        )
        val reader = MessageNotificationReader(map)
        assertEquals("2023-01-01T00:00:00.000Z", reader.notificationTimestamp)
        assertEquals("cat1", reader.categoryIdentifier)
        assertEquals("thread1", reader.threadIdentifier)
        assertEquals("subtitle text", reader.subtitle)
        assertEquals("sound.wav", reader.sound)
        assertEquals("launch.png", reader.launchImageName)
        assertEquals("click", reader.action)
    }

    @Test
    fun createsNativeMessageNotificationEvent() {
        val reader = MessageNotificationReader(minimalMap)
        val event = reader.toMessageNotification()
        assertNotNull(event)
        assertTrue(event is MessageNotification)
    }

    @Test
    fun mapsPushTrigger() {
        val reader = MessageNotificationReader(mapOf("title" to "T", "body" to "B", "trigger" to "push"))
        val event = reader.toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun mapsLocationTrigger() {
        val reader = MessageNotificationReader(mapOf("title" to "T", "body" to "B", "trigger" to "location"))
        val event = reader.toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun mapsCalendarTrigger() {
        val reader = MessageNotificationReader(mapOf("title" to "T", "body" to "B", "trigger" to "calendar"))
        val event = reader.toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun mapsTimeIntervalTrigger() {
        val reader = MessageNotificationReader(mapOf("title" to "T", "body" to "B", "trigger" to "timeInterval"))
        val event = reader.toMessageNotification()
        assertNotNull(event)
    }

    @Test
    fun readsAttachments() {
        val map = minimalMap + mapOf(
            "attachments" to listOf(
                mapOf("identifier" to "id1", "type" to "image/png", "url" to "https://example.com/img.png")
            )
        )
        val reader = MessageNotificationReader(map)
        assertEquals(1, reader.attachments?.size)
    }
}
