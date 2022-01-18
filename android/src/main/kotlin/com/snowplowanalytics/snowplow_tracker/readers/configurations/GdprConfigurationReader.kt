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

package com.snowplowanalytics.snowplow_tracker.readers.configurations

import com.snowplowanalytics.snowplow.configuration.GdprConfiguration
import com.snowplowanalytics.snowplow.util.Basis

class GdprConfigurationReader(val values: Map<String, Any>) {
    val basisForProcessing: String by values
    val documentId: String by values
    val documentVersion: String by values
    val documentDescription: String by values

    fun toConfiguration(): GdprConfiguration {
        val basis = when (basisForProcessing) {
            "contract" -> Basis.CONTRACT
            "legal_obligation" -> Basis.LEGAL_OBLIGATION
            "legitimate_interests" -> Basis.LEGITIMATE_INTERESTS
            "public_task" -> Basis.PUBLIC_TASK
            "vital_interests" -> Basis.VITAL_INTERESTS
            else -> Basis.CONSENT
        }
        return GdprConfiguration(basis, documentId, documentVersion, documentDescription)
    }
}
