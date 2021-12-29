package com.snowplowanalytics.snowplow_flutter_tracker.readers.messages

import com.snowplowanalytics.snowplow.configuration.GlobalContextsConfiguration
import com.snowplowanalytics.snowplow.globalcontexts.GlobalContext
import com.snowplowanalytics.snowplow_flutter_tracker.readers.configurations.*

class CreateTrackerMessageReader(val values: Map<String, Any>) {
    val namespace: String by values
    val networkConfig: NetworkConfigurationReader by lazy {
        NetworkConfigurationReader(values.get("networkConfig") as Map<String, Any>)
    }
    val trackerConfig: TrackerConfigurationReader? by lazy {
        values.get("trackerConfig")?.let {
            TrackerConfigurationReader(it as Map<String, Any>)
        }
    }
    val sessionConfig: SessionConfigurationReader? by lazy {
        values.get("sessionConfig")?.let {
            SessionConfigurationReader(it as Map<String, Any>)
        }
    }
    val emitterConfig: EmitterConfigurationReader? by lazy {
        values.get("emitterConfig")?.let {
            EmitterConfigurationReader(it as Map<String, Any>)
        }
    }
    val subjectConfig: SubjectConfigurationReader? by lazy {
        values.get("subjectConfig")?.let {
            SubjectConfigurationReader(it as Map<String, Any>)
        }
    }
    val gdprConfig: GdprConfigurationReader? by lazy {
        values.get("gdprConfig")?.let {
            GdprConfigurationReader(it as Map<String, Any>)
        }
    }
    val gcConfig: List<GlobalContextsConfigurationReader>? by lazy {
        values.get("gcConfig")?.let {
            val configs = it as List<Map<String, Any>>
            configs.map { config -> GlobalContextsConfigurationReader(config) }
        }
    }

    fun toGlobalContextsConfiguration(): GlobalContextsConfiguration? {
        return gcConfig?.let {
            val contextGens = HashMap<String, GlobalContext>()

            it.forEach { config ->
                if (!contextGens.containsKey(config.tag)) {
                    contextGens.put(config.tag, config.toGlobalContext())
                }
            }

            GlobalContextsConfiguration(contextGens)
        }
    }
}