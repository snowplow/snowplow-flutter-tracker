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

package com.snowplowanalytics.snowplow_tracker.readers.messages

import com.snowplowanalytics.snowplow_tracker.readers.entities.MediaAdBreakEntityReader
import com.snowplowanalytics.snowplow_tracker.readers.entities.MediaAdEntityReader
import com.snowplowanalytics.snowplow_tracker.readers.entities.MediaPlayerEntityReader

class UpdateMediaTrackingMessageReader(val values: Map<String, Any>) {
    val tracker: String by values
    val mediaTrackingId: String by values

    val player: MediaPlayerEntityReader? by lazy {
        values.get("player")?.let {
            MediaPlayerEntityReader(it as Map<String, Any>)
        }
    }
    val ad: MediaAdEntityReader? by lazy {
        values.get("ad")?.let {
            MediaAdEntityReader(it as Map <String, Any>)
        }
    }
    val adBreak: MediaAdBreakEntityReader? by lazy {
        values.get("adBreak")?.let {
            MediaAdBreakEntityReader(it as Map <String, Any>)
        }
    }
}
