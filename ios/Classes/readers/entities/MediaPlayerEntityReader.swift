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

import Foundation
import SnowplowTracker

struct MediaPlayerEntityReader: Decodable {
    let currentTime: Double?
    let duration: Double?
    let ended: Bool?
    let fullscreen: Bool?
    let livestream: Bool?
    let label: String?
    let loop: Bool?
    let mediaType: String?
    let muted: Bool?
    let paused: Bool?
    let pictureInPicture: Bool?
    let playerType: String?
    let playbackRate: Double?
    let quality: String?
    let volume: Int?
    
    var mediaTypeEnum: MediaType? {
        if let mediaType = self.mediaType {
            switch mediaType {
            case "audio":
                return MediaType.audio
            case "video":
                return MediaType.video
            default:
                return nil
            }
        }
        return nil
    }
}

extension MediaPlayerEntityReader {
    func toMediaPlayerEntity() -> MediaPlayerEntity {
        let player = MediaPlayerEntity(
            currentTime: self.currentTime,
            duration: self.duration,
            ended: self.ended,
            fullscreen: self.fullscreen,
            livestream: self.livestream,
            label: self.label,
            loop: self.loop,
            mediaType: self.mediaTypeEnum,
            muted: self.muted,
            paused: self.paused,
            pictureInPicture: self.pictureInPicture,
            playerType: self.playerType,
            playbackRate: self.playbackRate,
            quality: self.quality,
            volume: self.volume
        )
        return player
    }
}
