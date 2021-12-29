package com.snowplowanalytics.snowplow_flutter_tracker.readers.configurations

import com.snowplowanalytics.snowplow.configuration.EmitterConfiguration
import com.snowplowanalytics.snowplow.emitter.BufferOption

class EmitterConfigurationReader(val values: Map<String, Any>) {
    private val valuesDefault = values.withDefault { null }

    val bufferOption: String? by valuesDefault
    val emitRange: Double? by valuesDefault
    val threadPoolSize: Double? by valuesDefault
    val byteLimitPost: Double? by valuesDefault
    val byteLimitGet: Double? by valuesDefault

    fun toConfiguration(): EmitterConfiguration {
        val emitterConfig = EmitterConfiguration()

        bufferOption?.let {
            emitterConfig.bufferOption(when (it) {
                "default" -> BufferOption.DefaultGroup
                "heavy" -> BufferOption.HeavyGroup
                else -> BufferOption.Single
            })
        }
        emitRange?.let { emitterConfig.emitRange(it.toInt()) }
        threadPoolSize?.let { emitterConfig.threadPoolSize(it.toInt()) }
        byteLimitPost?.let { emitterConfig.byteLimitPost(it.toInt()) }
        byteLimitGet?.let { emitterConfig.byteLimitGet(it.toInt()) }

        return emitterConfig
    }
}
