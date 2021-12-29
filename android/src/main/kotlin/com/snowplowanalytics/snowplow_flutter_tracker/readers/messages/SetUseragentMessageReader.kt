package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

class SetUseragentMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    val useragent: String? by valuesDefault
}