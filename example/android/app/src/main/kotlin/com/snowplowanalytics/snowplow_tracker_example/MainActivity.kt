package com.snowplowanalytics.snowplow_tracker_example

import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    /// A second engine, used by the integration tests to check that plugins keep working in this one
    private var secondaryEngine: FlutterEngine? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "snowplow_tracker_example/engines")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startSecondaryEngine" -> {
                        startSecondaryEngine(call.arguments as String)
                        result.success(null)
                    }
                    "destroySecondaryEngine" -> {
                        destroySecondaryEngine()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        destroySecondaryEngine()
        super.onDestroy()
    }

    /// Starts an engine with plugins registered automatically, as apps do for background work
    private fun startSecondaryEngine(entrypoint: String) {
        destroySecondaryEngine()
        val appBundlePath = FlutterInjector.instance().flutterLoader().findAppBundlePath()
        secondaryEngine = FlutterEngineGroup(applicationContext).createAndRunEngine(
            FlutterEngineGroup.Options(applicationContext)
                .setDartEntrypoint(DartExecutor.DartEntrypoint(appBundlePath, entrypoint))
                .setAutomaticallyRegisterPlugins(true)
        )
    }

    private fun destroySecondaryEngine() {
        secondaryEngine?.destroy()
        secondaryEngine = null
    }
}
