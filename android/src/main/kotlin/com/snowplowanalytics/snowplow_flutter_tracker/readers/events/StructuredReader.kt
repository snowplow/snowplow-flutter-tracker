package com.snowplowanalytics.snowplow_flutter_tracker.readers.events

import com.snowplowanalytics.snowplow.event.Structured

class StructuredReader(values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val category: String by values
    val action: String by values
    val label: String? by valuesDefault
    val property: String? by valuesDefault
    val value: Double? by valuesDefault

    fun toStructured(): Structured {
        val structured = Structured(category, action)
        label?.let { structured.label(it) }
        property?.let { structured.property(it) }
        value?.let { structured.value(it) }
        return structured
    }
}