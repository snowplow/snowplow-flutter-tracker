package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

class RemoveTrackerMessageReader(val values: Map<String, Any>) {
    val tracker: String by values
}