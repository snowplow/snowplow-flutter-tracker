package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.ConsentWithdrawn

class ConsentWithdrawnReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val all: Boolean by values
    val documentId: String by values
    val version: String by values
    val name: String? by valuesDefault
    val documentDescription: String? by valuesDefault

    fun toConsentWithdrawn(): ConsentWithdrawn {
        val consentWithdrawn = ConsentWithdrawn(all, documentId, version)
        name?.let { consentWithdrawn.documentName(it) }
        documentDescription?.let { consentWithdrawn.documentDescription(it) }
        return consentWithdrawn
    }
}