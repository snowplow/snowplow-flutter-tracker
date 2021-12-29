package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

class SetDomainUserIdMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    val domainUserId: String? by valuesDefault
}