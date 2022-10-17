// Copyright (c) 2022 Snowplow Analytics Ltd. All rights reserved.
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

import com.snowplowanalytics.snowplow_tracker.readers.configurations.*

class CreateTrackerMessageReader(val values: Map<String, Any>) {
    val namespace: String by values
    val networkConfig: NetworkConfigurationReader by lazy {
        NetworkConfigurationReader(values.get("networkConfig") as Map<String, Any>)
    }
    val trackerConfig: TrackerConfigurationReader? by lazy {
        values.get("trackerConfig")?.let {
            TrackerConfigurationReader(it as Map<String, Any>)
        }
    }
    val subjectConfig: SubjectConfigurationReader? by lazy {
        values.get("subjectConfig")?.let {
            SubjectConfigurationReader(it as Map<String, Any>)
        }
    }
    val gdprConfig: GdprConfigurationReader? by lazy {
        values.get("gdprConfig")?.let {
            GdprConfigurationReader(it as Map<String, Any>)
        }
    }
    val emitterConfig: EmitterConfigurationReader? by lazy {
        values.get("emitterConfig")?.let {
            EmitterConfigurationReader(it as Map<String, Any>)
        }
    }
}
