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

import com.snowplowanalytics.snowplow.event.DeepLinkReceived
import org.junit.Test
import org.junit.Assert.*

class DeepLinkReceivedReaderTest {

    @Test
    fun readsUrlCorrectly() {
        val reader = DeepLinkReceivedReader(mapOf("url" to "https://example.com"))
        assertEquals("https://example.com", reader.url)
    }

    @Test
    fun referrerIsNullWhenNotProvided() {
        val reader = DeepLinkReceivedReader(mapOf("url" to "https://example.com"))
        assertNull(reader.referrer)
    }

    @Test
    fun readsOptionalReferrer() {
        val reader = DeepLinkReceivedReader(
            mapOf(
                "url" to "https://example.com",
                "referrer" to "https://referrer.com"
            )
        )
        assertEquals("https://referrer.com", reader.referrer)
    }

    @Test
    fun createsNativeDeepLinkReceivedEvent() {
        val reader = DeepLinkReceivedReader(mapOf("url" to "https://example.com"))
        val event = reader.toDeepLinkReceived()
        assertNotNull(event)
        assertTrue(event is DeepLinkReceived)
    }

    @Test
    fun createsNativeEventWithReferrer() {
        val reader = DeepLinkReceivedReader(
            mapOf(
                "url" to "https://example.com",
                "referrer" to "https://referrer.com"
            )
        )
        val event = reader.toDeepLinkReceived()
        assertNotNull(event)
    }
}
