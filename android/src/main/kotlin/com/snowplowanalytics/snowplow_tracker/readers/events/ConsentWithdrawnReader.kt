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

package com.snowplowanalytics.snowplow_tracker.readers.events

import com.snowplowanalytics.snowplow.event.ConsentDocument
import com.snowplowanalytics.snowplow.event.ConsentWithdrawn

class ConsentWithdrawnReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val all: Boolean by values
    val documentId: String by values
    val version: String by values
    val name: String? by valuesDefault
    val documentDescription: String? by valuesDefault
    val consentDocuments: List<Map<String, Any>>? by valuesDefault
    private val processedConsentDocuments: List<ConsentDocument>? by lazy {
        consentDocuments?.let { it.map { ConsentDocumentReader(it).toConsentDocument() } }
    }

    fun toConsentWithdrawn(): ConsentWithdrawn {
        val consentWithdrawn = ConsentWithdrawn(all, documentId, version)
        name?.let { consentWithdrawn.documentName(it) }
        documentDescription?.let { consentWithdrawn.documentDescription(it) }
        processedConsentDocuments?.let { consentWithdrawn.documents(it) }
        return consentWithdrawn
    }
}
