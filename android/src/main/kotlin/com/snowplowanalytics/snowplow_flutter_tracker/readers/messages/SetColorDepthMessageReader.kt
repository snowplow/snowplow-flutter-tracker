package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

class SetColorDepthMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    val colorDepth: Int? by valuesDefault
}