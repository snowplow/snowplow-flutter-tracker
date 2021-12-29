package com.snowplowanalytics.snowplow_flutter_tracker.readers.configurations

import com.snowplowanalytics.snowplow.configuration.NetworkConfiguration
import com.snowplowanalytics.snowplow.network.HttpMethod

class NetworkConfigurationReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val endpoint: String by values
    val method: String? by valuesDefault

    fun toConfiguration(): NetworkConfiguration {
        if (method != null) {
            return NetworkConfiguration(
               endpoint,
               if ("get".equals(method, true)) { HttpMethod.GET } else { HttpMethod.POST }
            )
        } else {
            return NetworkConfiguration(endpoint)
        }
    }
}
