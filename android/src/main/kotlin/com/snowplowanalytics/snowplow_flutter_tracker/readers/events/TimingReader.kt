package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.Timing

class TimingReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val category: String by values
    val variable: String by values
    val timing: Int by values
    val label: String? by valuesDefault

    fun toTiming(): Timing {
        val timing = Timing(category, variable, timing)
        label?.let { timing.label(it) }
        return timing
    }
}