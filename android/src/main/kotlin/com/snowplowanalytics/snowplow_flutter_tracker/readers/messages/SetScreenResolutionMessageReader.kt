package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

import com.snowplowanalytics.snowplow.util.Size

class SetScreenResolutionMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    private val screenResolution: Pair<Double, Double>? by valuesDefault
    val screenResolutionSize: Size? by lazy {
        screenResolution?.let {
            val screenWidth = it.first.toInt()
            val screenHeight = it.second.toInt()
            Size(screenWidth, screenHeight)
        }
    }
}