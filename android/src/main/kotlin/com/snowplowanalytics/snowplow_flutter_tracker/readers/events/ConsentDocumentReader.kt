package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.ConsentDocument

class ConsentDocumentReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val documentId: String by values
    val documentVersion: String by values
    val documentName: String? by valuesDefault
    val documentDescription: String? by valuesDefault

    fun toConsentDocument(): ConsentDocument {
        val consentDocument = ConsentDocument(documentId, documentVersion)
        documentName?.let { consentDocument.documentName(it) }
        documentDescription?.let { consentDocument.documentDescription(it) }
        return consentDocument
    }
}