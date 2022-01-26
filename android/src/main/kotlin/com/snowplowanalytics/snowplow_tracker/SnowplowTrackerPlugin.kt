// Copyright (c) 2022 Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

package com.snowplowanalytics.snowplow_tracker

import androidx.annotation.NonNull

import android.content.Context
import com.snowplowanalytics.snowplow_tracker.readers.messages.CreateTrackerMessageReader
import com.snowplowanalytics.snowplow_tracker.readers.messages.EventMessageReader
import com.snowplowanalytics.snowplow_tracker.readers.messages.GetParameterMessageReader
import com.snowplowanalytics.snowplow_tracker.readers.messages.SetUserIdMessageReader
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SnowplowTrackerPlugin */
class SnowplowTrackerPlugin: FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "snowplow_tracker")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "createTracker" -> onCreateTracker(call, result)
            "trackStructured" -> onTrackStructured(call, result)
            "trackSelfDescribing" -> onTrackSelfDescribing(call, result)
            "trackScreenView" -> onTrackScreenView(call, result)
            "trackTiming" -> onTrackTiming(call, result)
            "trackConsentGranted" -> onTrackConsentGranted(call, result)
            "trackConsentWithdrawn" -> onTrackConsentWithdrawn(call, result)
            "setUserId" -> onSetUserId(call, result)
            "getSessionUserId" -> onGetSessionUserId(call, result)
            "getSessionId" -> onGetSessionId(call, result)
            "getSessionIndex" -> onGetSessionIndex(call, result)
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
                SnowplowTrackerController.createTracker(CreateTrackerMessageReader(values), ctxt)
            }
        }
        result.success(null)
    }

    private fun onTrackStructured(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackStructured(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackSelfDescribing(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackSelfDescribing(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackScreenView(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackScreenView(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackTiming(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackTiming(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackConsentGranted(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackConsentGranted(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackConsentWithdrawn(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackConsentWithdrawn(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onSetUserId(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.setUserId(SetUserIdMessageReader(it))
        }
        result.success(null)
    }

    private fun onGetSessionUserId(call: MethodCall, result: MethodChannel.Result) {
        val sessionUserId = (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.getSessionUserId(GetParameterMessageReader(it))
        }
        result.success(sessionUserId)
    }

    private fun onGetSessionId(call: MethodCall, result: MethodChannel.Result) {
        val sessionId = (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.getSessionId(GetParameterMessageReader(it))
        }
        result.success(sessionId)
    }

    private fun onGetSessionIndex(call: MethodCall, result: MethodChannel.Result) {
        val sessionIndex = (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.getSessionIndex(GetParameterMessageReader(it))
        }
        result.success(sessionIndex)
    }

}
