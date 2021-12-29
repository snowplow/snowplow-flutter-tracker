package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.SelfDescribing
import com.snowplowanalytics.snowplow.payload.SelfDescribingJson

class SelfDescribingJsonReader(val values: Map<String, Any>) {
    val schema: String by values
    val data: Map<String, Any> by values

    fun toSelfDescribingJson(): SelfDescribingJson {
        return SelfDescribingJson(schema, data)
    }

    fun toSelfDescribing(): SelfDescribing {
        return SelfDescribing(toSelfDescribingJson())
    }
}