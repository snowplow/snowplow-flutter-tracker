package com.snowplowanalytics.snowplow_flutter_tracker

import androidx.annotation.NonNull

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SnowplowFlutterTrackerPlugin */
class SnowplowFlutterTrackerPlugin: FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "snowplow_flutter_tracker")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "createTracker" -> onCreateTracker(call, result)
            "removeTracker" -> onRemoveTracker(call, result)
            "removeAllTrackers" -> onRemoveAllTrackers(result)
            "trackStructured" -> onTrackStructured(call, result)
            "trackSelfDescribing" -> onTrackSelfDescribing(call, result)
            "trackScreenView" -> onTrackScreenView(call, result)
            "trackTiming" -> onTrackTiming(call, result)
            "trackConsentGranted" -> onTrackConsentGranted(call, result)
            "trackConsentWithdrawn" -> onTrackConsentWithdrawn(call, result)
            "setUserId" -> onSetUserId(call, result)
            "setNetworkUserId" -> onSetNetworkUserId(call, result)
            "setDomainUserId" -> onSetDomainUserId(call, result)
            "setIpAddress" -> onSetIpAddress(call, result)
            "setUseragent" -> onSetUseragent(call, result)
            "setTimezone" -> onSetTimezone(call, result)
            "setLanguage" -> onSetLanguage(call, result)
            "setScreenResolution" -> onSetScreenResolution(call, result)
            "setScreenViewport" -> onSetScreenViewport(call, result)
            "setColorDepth" -> onSetColorDepth(call, result)
            "getSessionUserId" -> onGetSessionUserId(call, result)
            "getSessionId" -> onGetSessionId(call, result)
            "getSessionIndex" -> onGetSessionIndex(call, result)
            "getIsInBackground" -> onGetIsInBackground(call, result)
            "getBackgroundIndex" -> onGetBackgroundIndex(call, result)
            "getForegroundIndex" -> onGetForegroundIndex(call, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    private fun onCreateTracker(call: MethodCall, result: MethodChannel.Result) {
        context?.let { ctxt ->
            (call.arguments as? Map<String, Any>)?.let { values ->
                SnowplowFlutterTrackerController.createTracker(values, ctxt)
            }
        }
        result.success(null)
    }

    private fun onRemoveTracker(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.removeTracker(it)
        }
        result.success(null)
    }

    private fun onRemoveAllTrackers(result: MethodChannel.Result) {
        SnowplowFlutterTrackerController.removeAllTrackers()
        result.success(null)
    }

    private fun onTrackStructured(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.trackStructured(it)
        }
        result.success(null)
    }

    private fun onTrackSelfDescribing(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.trackSelfDescribing(it)
        }
        result.success(null)
    }

    private fun onTrackScreenView(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.trackScreenView(it)
        }
        result.success(null)
    }

    private fun onTrackTiming(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.trackTiming(it)
        }
        result.success(null)
    }

    private fun onTrackConsentGranted(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.trackConsentGranted(it)
        }
        result.success(null)
    }

    private fun onTrackConsentWithdrawn(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.trackConsentWithdrawn(it)
        }
        result.success(null)
    }

    private fun onSetUserId(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setUserId(it)
        }
        result.success(null)
    }

    private fun onSetNetworkUserId(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setNetworkUserId(it)
        }
        result.success(null)
    }

    private fun onSetDomainUserId(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setDomainUserId(it)
        }
        result.success(null)
    }

    private fun onSetIpAddress(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setIpAddress(it)
        }
        result.success(null)
    }

    private fun onSetUseragent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setUseragent(it)
        }
        result.success(null)
    }

    private fun onSetTimezone(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setTimezone(it)
        }
        result.success(null)
    }

    private fun onSetLanguage(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setLanguage(it)
        }
        result.success(null)
    }

    private fun onSetScreenResolution(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setScreenResolution(it)
        }
        result.success(null)
    }

    private fun onSetScreenViewport(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setScreenViewport(it)
        }
        result.success(null)
    }

    private fun onSetColorDepth(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.setColorDepth(it)
        }
        result.success(null)
    }

    private fun onGetSessionUserId(call: MethodCall, result: MethodChannel.Result) {
        val sessionUserId = (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.getSessionUserId(it)
        }
        result.success(sessionUserId)
    }

    private fun onGetSessionId(call: MethodCall, result: MethodChannel.Result) {
        val sessionId = (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.getSessionId(it)
        }
        result.success(sessionId)
    }

    private fun onGetSessionIndex(call: MethodCall, result: MethodChannel.Result) {
        val sessionIndex = (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.getSessionIndex(it)
        }
        result.success(sessionIndex)
    }

    private fun onGetIsInBackground(call: MethodCall, result: MethodChannel.Result) {
        val isInBackground = (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.getIsInBackground(it)
        }
        result.success(isInBackground)
    }

    private fun onGetBackgroundIndex(call: MethodCall, result: MethodChannel.Result) {
        val backgroundIndex = (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.getBackgroundIndex(it)
        }
        result.success(backgroundIndex)
    }

    private fun onGetForegroundIndex(call: MethodCall, result: MethodChannel.Result) {
        val foregroundIndex = (call.arguments as? Map<String, Any>)?.let {
            SnowplowFlutterTrackerController.getForegroundIndex(it)
        }
        result.success(foregroundIndex)
    }


}
