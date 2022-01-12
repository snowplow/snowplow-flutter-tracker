package com.snowplowanalytics.snowplow_flutter_tracker.readers.configurations

import android.content.Context
import com.snowplowanalytics.snowplow.configuration.TrackerConfiguration
import com.snowplowanalytics.snowplow.tracker.DevicePlatform
import com.snowplowanalytics.snowplow.tracker.LogLevel
import com.snowplowanalytics.snowplow_flutter_tracker.TrackerVersion

class TrackerConfigurationReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val appId: String? by valuesDefault
    val devicePlatform: String? by valuesDefault
    val base64Encoding: Boolean? by valuesDefault
    val platformContext: Boolean? by valuesDefault
    val geoLocationContext: Boolean? by valuesDefault
    val sessionContext: Boolean? by valuesDefault

    fun toConfiguration(context: Context): TrackerConfiguration {
        val trackerConfig = TrackerConfiguration(appId ?: context.getPackageName())
                .trackerVersionSuffix(TrackerVersion.TRACKER_VERSION)

        devicePlatform?.let {
            trackerConfig.devicePlatform(when (it) {
                "web" -> DevicePlatform.Web
                "srv" -> DevicePlatform.ServerSideApp
                "pc" -> DevicePlatform.Desktop
                "app" -> DevicePlatform.General
                "tv" -> DevicePlatform.ConnectedTV
                "cnsl" -> DevicePlatform.GameConsole
                "iot" -> DevicePlatform.InternetOfThings
                else -> trackerConfig.devicePlatform
            })
        }
        base64Encoding?.let { trackerConfig.base64encoding(it) }
        platformContext?.let { trackerConfig.platformContext(it) }
        geoLocationContext?.let { trackerConfig.geoLocationContext(it) }
        sessionContext?.let { trackerConfig.sessionContext(it) }

        trackerConfig.applicationContext(false)
        trackerConfig.screenContext(false)
        trackerConfig.screenViewAutotracking(false)
        trackerConfig.lifecycleAutotracking(false)
        trackerConfig.installAutotracking(false)
        trackerConfig.exceptionAutotracking(false)
        trackerConfig.diagnosticAutotracking(false)

        return trackerConfig
    }
}
