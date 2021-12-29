package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

import com.snowplowanalytics.snowplow.util.Size

class SetScreenViewportMessageReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val tracker: String by values
    private val screenViewport: Pair<Double, Double>? by valuesDefault
    val screenViewportSize: Size? by lazy {
        screenViewport?.let {
            val screenWidth = it.first.toInt()
            val screenHeight = it.second.toInt()
            Size(screenWidth, screenHeight)
        }
    }
}