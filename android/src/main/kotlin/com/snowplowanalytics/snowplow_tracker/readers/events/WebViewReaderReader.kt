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

import com.snowplowanalytics.core.event.WebViewReader

class WebViewReaderReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val selfDescribingEventData: Map<String, Any>? by valuesDefault
    val eventName: String? by valuesDefault
    val trackerVersion: String? by valuesDefault
    val useragent: String? by valuesDefault
    val pageUrl: String? by valuesDefault
    val pageTitle: String? by valuesDefault
    val referrer: String? by valuesDefault
    val category: String? by valuesDefault
    val action: String? by valuesDefault
    val label: String? by valuesDefault
    val property: String? by valuesDefault
    val value: Double? by valuesDefault
    val pingXOffsetMin: Int? by valuesDefault
    val pingXOffsetMax: Int? by valuesDefault
    val pingYOffsetMin: Int? by valuesDefault
    val pingYOffsetMax: Int? by valuesDefault

    fun toWebViewReader(): WebViewReader {
        return WebViewReader(
            selfDescribingEventData = selfDescribingEventData?.let {
                SelfDescribingJsonReader(it).toSelfDescribingJson()
            },
            eventName = eventName,
            trackerVersion = trackerVersion,
            useragent = useragent,
            pageUrl = pageUrl,
            pageTitle = pageTitle,
            referrer = referrer,
            category = category,
            action = action,
            label = label,
            property = property,
            value = value,
            pingXOffsetMin = pingXOffsetMin,
            pingXOffsetMax = pingXOffsetMax,
            pingYOffsetMin = pingYOffsetMin,
            pingYOffsetMax = pingYOffsetMax
        )
    }
}
