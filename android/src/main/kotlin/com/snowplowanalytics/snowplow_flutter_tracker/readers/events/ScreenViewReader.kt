package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.ScreenView
import java.util.*

class ScreenViewReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val name: String by values
    private val id: String? by valuesDefault
    val idUUID: UUID? by lazy { id?.let { UUID.fromString(it) } }
    val type: String? by valuesDefault
    val previousName: String? by valuesDefault
    val previousType: String? by valuesDefault
    val previousId: String? by valuesDefault
    val transitionType: String? by valuesDefault

    fun toScreenView(): ScreenView {
        val screenView = ScreenView(name, idUUID)
        type?.let { screenView.type(it) }
        previousName?.let { screenView.previousName(it) }
        previousType?.let { screenView.previousType(it) }
        previousId?.let { screenView.previousId(it) }
        transitionType?.let { screenView.transitionType(it) }
        return screenView
    }
}
