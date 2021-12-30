package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.ConsentDocument
import com.snowplowanalytics.snowplow.event.ConsentGranted

class ConsentGrantedReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val expiry: String by values
    val documentId: String by values
    val version: String by values
    val name: String? by valuesDefault
    val documentDescription: String? by valuesDefault
    val consentDocuments: List<Map<String, Any>>? by valuesDefault
    private val processedConsentDocuments: List<ConsentDocument>? by lazy {
        consentDocuments?.let { it.map { ConsentDocumentReader(it).toConsentDocument() } }
    }

    fun toConsentGranted(): ConsentGranted {
        val consentGranted = ConsentGranted(expiry, documentId, version)
        name?.let { consentGranted.documentName(it) }
        documentDescription?.let { consentGranted.documentDescription(it) }
        processedConsentDocuments?.let { consentGranted.documents(it) }
        return consentGranted
    }
}
