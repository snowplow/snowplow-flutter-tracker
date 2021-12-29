package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

class SetUserIdMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    val userId: String? by valuesDefault
}