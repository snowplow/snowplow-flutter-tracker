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

struct WebViewReaderReader: Decodable {
    let selfDescribingEventData: SelfDescribingJsonReader?
    let eventName: String?
    let trackerVersion: String?
    let useragent: String?
    let pageUrl: String?
    let pageTitle: String?
    let referrer: String?
    let category: String?
    let action: String?
    let label: String?
    let property: String?
    let value: Double?
    let pingXOffsetMin: Int?
    let pingXOffsetMax: Int?
    let pingYOffsetMin: Int?
    let pingYOffsetMax: Int?
}

extension WebViewReaderReader {
    func toWebViewReader(arguments: [String: Any]) -> WebViewReader {
        var eventData: SelfDescribingJson?
        if let data = arguments["eventData"] as? [String: Any],
           let args = data["selfDescribingEventData"] as? [String: Any] {
            eventData = selfDescribingEventData?.toSelfDescribingJson(arguments: args)
        }
        
        let event = WebViewReader(
            selfDescribingEventData: eventData,
            eventName: eventName,
            trackerVersion: trackerVersion,
            useragent: useragent,
            pageUrl: pageUrl,
            pageTitle: pageTitle,
            referrer: referrer,
            category: category,
            action: action,
            label: label,
            property: property,
            value: value,
            pingXOffsetMin: pingXOffsetMin,
            pingXOffsetMax: pingXOffsetMax,
            pingYOffsetMin: pingYOffsetMin,
            pingYOffsetMax: pingYOffsetMax
        )

        return event
    }
}
