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

class DeepLinkReceivedReaderTest {

    @Test
    fun `reads required url field`() {
        val map = mapOf<String, Any>("url" to "https://example.com")
        val reader = DeepLinkReceivedReader(map)
        assertEquals("https://example.com", reader.url)
    }

    @Test
    fun `referrer is null when not provided`() {
        val map = mapOf<String, Any>("url" to "https://example.com")
        val reader = DeepLinkReceivedReader(map)
        assertNull(reader.referrer)
    }

    @Test
    fun `reads optional referrer field`() {
        val map = mapOf<String, Any>(
            "url" to "https://example.com",
            "referrer" to "https://referrer.com"
        )
        val reader = DeepLinkReceivedReader(map)
        assertEquals("https://example.com", reader.url)
        assertEquals("https://referrer.com", reader.referrer)
    }

    @Test
    fun `toDeepLinkReceived creates event with url`() {
        val map = mapOf<String, Any>("url" to "https://example.com")
        val reader = DeepLinkReceivedReader(map)
        val event = reader.toDeepLinkReceived()
        assertNotNull(event)
    }

    @Test
    fun `toDeepLinkReceived creates event with url and referrer`() {
        val map = mapOf<String, Any>(
            "url" to "https://example.com",
            "referrer" to "https://referrer.com"
        )
        val reader = DeepLinkReceivedReader(map)
        val event = reader.toDeepLinkReceived()
        assertNotNull(event)
    }
}
