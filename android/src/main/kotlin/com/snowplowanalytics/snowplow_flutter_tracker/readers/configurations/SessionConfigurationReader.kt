package com.snowplowanalytics.snowplow_flutter_tracker.readers.configurations

import com.snowplowanalytics.snowplow.configuration.SessionConfiguration
import com.snowplowanalytics.snowplow.util.TimeMeasure
import java.util.concurrent.TimeUnit

class SessionConfigurationReader(val values: Map<String, Any>) {
    val foregroundTimeout: Double by values
    val backgroundTimeout: Double by values

    fun toConfiguration(): SessionConfiguration {
        val sessionConfig = SessionConfiguration(
                TimeMeasure(foregroundTimeout.toLong(), TimeUnit.SECONDS),
                TimeMeasure(backgroundTimeout.toLong(), TimeUnit.SECONDS)
        )
        return sessionConfig
    }
}
