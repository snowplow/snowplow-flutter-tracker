package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

import com.snowplowanalytics.snowplow_flutter_tracker.readers.configurations.*

class CreateTrackerMessageReader(val values: Map<String, Any>) {
    val namespace: String by values
    val networkConfig: NetworkConfigurationReader by lazy {
        NetworkConfigurationReader(values.get("networkConfig") as Map<String, Any>)
    }
    val trackerConfig: TrackerConfigurationReader? by lazy {
        values.get("trackerConfig")?.let {
            TrackerConfigurationReader(it as Map<String, Any>)
        }
    }
    val subjectConfig: SubjectConfigurationReader? by lazy {
        values.get("subjectConfig")?.let {
            SubjectConfigurationReader(it as Map<String, Any>)
        }
    }
    val gdprConfig: GdprConfigurationReader? by lazy {
        values.get("gdprConfig")?.let {
            GdprConfigurationReader(it as Map<String, Any>)
        }
    }
}
