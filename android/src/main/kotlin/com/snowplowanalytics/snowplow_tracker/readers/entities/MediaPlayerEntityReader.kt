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

package com.snowplowanalytics.snowplow_tracker.readers.entities

import com.snowplowanalytics.snowplow.media.entity.MediaPlayerEntity
import com.snowplowanalytics.snowplow.media.entity.MediaType

class MediaPlayerEntityReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val currentTime: Double? by valuesDefault
    val duration: Double? by valuesDefault
    val ended: Boolean? by valuesDefault
    val fullscreen: Boolean? by valuesDefault
    val livestream: Boolean? by valuesDefault
    val label: String? by valuesDefault
    val loop: Boolean? by valuesDefault
    val mediaType: String? by valuesDefault
    val muted: Boolean? by valuesDefault
    val paused: Boolean? by valuesDefault
    val pictureInPicture: Boolean? by valuesDefault
    val playerType: String? by valuesDefault
    val playbackRate: Double? by valuesDefault
    val quality: String? by valuesDefault
    val volume: Int? by valuesDefault

    val mediaTypeEnum: MediaType? by lazy {
        when (mediaType) {
            "audio" -> MediaType.Audio
            "video" -> MediaType.Video
            else -> null
        }
    }

    fun toMediaPlayerEntity(): MediaPlayerEntity {
        return MediaPlayerEntity(
            currentTime = currentTime,
            duration = duration,
            ended = ended,
            fullscreen = fullscreen,
            livestream = livestream,
            label = label,
            loop = loop,
            mediaType = mediaTypeEnum,
            muted = muted,
            paused = paused,
            pictureInPicture = pictureInPicture,
            playerType = playerType,
            playbackRate = playbackRate,
            quality = quality,
            volume = volume
        )
    }
}
