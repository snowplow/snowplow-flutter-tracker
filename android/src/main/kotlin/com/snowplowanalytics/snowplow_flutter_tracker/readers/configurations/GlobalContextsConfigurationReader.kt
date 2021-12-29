package com.snowplowanalytics.snowplow_flutter_tracker.readers.configurations

import com.snowplowanalytics.snowplow.globalcontexts.GlobalContext
import com.snowplowanalytics.snowplow_flutter_tracker.readers.events.SelfDescribingJsonReader

class GlobalContextsConfigurationReader(val values: Map<String, Any>) {
    val tag: String by values
    val globalContexts: List<Map<String, Any>> by values

    fun toGlobalContext(): GlobalContext {
        val staticContexts = globalContexts.map { globalContext ->
            SelfDescribingJsonReader(globalContext).toSelfDescribingJson()
        }
        return GlobalContext(staticContexts)
    }

}
