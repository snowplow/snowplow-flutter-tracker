package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

class SetNetworkUserIdMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    val networkUserId: String? by valuesDefault
}