package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.ConsentGranted

class ConsentGrantedReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val expiry: String by values
    val documentId: String by values
    val version: String by values
    val name: String? by valuesDefault
    val documentDescription: String? by valuesDefault

    fun toConsentGranted(): ConsentGranted {
        val consentGranted = ConsentGranted(expiry, documentId, version)
        name?.let { consentGranted.documentName(it) }
        documentDescription?.let { consentGranted.documentDescription(it) }
        return consentGranted
    }
}