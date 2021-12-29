package com.snowplowanalytics.snowplow_flutter_tracker.readers.configurations

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
