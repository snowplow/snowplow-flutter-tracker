// Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
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
import com.snowplowanalytics.snowplow_tracker.readers.messages.*
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
    private lateinit var channel: MethodChannel
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
            "trackScrollChanged" -> onTrackScrollChanged(call, result)
            "trackListItemView" -> onTrackListItemView(call, result)
            "trackTiming" -> onTrackTiming(call, result)
            "trackConsentGranted" -> onTrackConsentGranted(call, result)
            "trackConsentWithdrawn" -> onTrackConsentWithdrawn(call, result)
            "setUserId" -> onSetUserId(call, result)
            "getSessionUserId" -> onGetSessionUserId(call, result)
            "getSessionId" -> onGetSessionId(call, result)
            "getSessionIndex" -> onGetSessionIndex(call, result)
            "startMediaTracking" -> onStartMediaTracking(call, result)
            "endMediaTracking" -> onEndMediaTracking(call, result)
            "updateMediaTracking" -> onUpdateMediaTracking(call, result)
            "trackMediaAdBreakEndEvent" -> onTrackMediaAdBreakEndEvent(call, result)
            "trackMediaAdBreakStartEvent" -> onTrackMediaAdBreakStartEvent(call, result)
            "trackMediaAdClickEvent" -> onTrackMediaAdClickEvent(call, result)
            "trackMediaAdCompleteEvent" -> onTrackMediaAdCompleteEvent(call, result)
            "trackMediaAdFirstQuartileEvent" -> onTrackMediaAdFirstQuartileEvent(call, result)
            "trackMediaAdMidpointEvent" -> onTrackMediaAdMidpointEvent(call, result)
            "trackMediaAdPauseEvent" -> onTrackMediaAdPauseEvent(call, result)
            "trackMediaAdResumeEvent" -> onTrackMediaAdResumeEvent(call, result)
            "trackMediaAdSkipEvent" -> onTrackMediaAdSkipEvent(call, result)
            "trackMediaAdStartEvent" -> onTrackMediaAdStartEvent(call, result)
            "trackMediaAdThirdQuartileEvent" -> onTrackMediaAdThirdQuartileEvent(call, result)
            "trackMediaBufferEndEvent" -> onTrackMediaBufferEndEvent(call, result)
            "trackMediaBufferStartEvent" -> onTrackMediaBufferStartEvent(call, result)
            "trackMediaEndEvent" -> onTrackMediaEndEvent(call, result)
            "trackMediaErrorEvent" -> onTrackMediaErrorEvent(call, result)
            "trackMediaFullscreenChangeEvent" -> onTrackMediaFullscreenChangeEvent(call, result)
            "trackMediaPauseEvent" -> onTrackMediaPauseEvent(call, result)
            "trackMediaPictureInPictureChangeEvent" -> onTrackMediaPictureInPictureChangeEvent(
                call,
                result
            )
            "trackMediaPlayEvent" -> onTrackMediaPlayEvent(call, result)
            "trackMediaPlaybackRateChangeEvent" -> onTrackMediaPlaybackRateChangeEvent(call, result)
            "trackMediaQualityChangeEvent" -> onTrackMediaQualityChangeEvent(call, result)
            "trackMediaReadyEvent" -> onTrackMediaReadyEvent(call, result)
            "trackMediaSeekEndEvent" -> onTrackMediaSeekEndEvent(call, result)
            "trackMediaSeekStartEvent" -> onTrackMediaSeekStartEvent(call, result)
            "trackMediaVolumeChangeEvent" -> onTrackMediaVolumeChangeEvent(call, result)
            "trackWebViewReader" -> onTrackWebViewReaderEvent(call, result)
            "trackPageView" -> onTrackPageView(call, result)
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

    private fun onTrackScrollChanged(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackScrollChanged(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackListItemView(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackListItemView(EventMessageReader(it))
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

    private fun onStartMediaTracking(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.startMediaTracking(StartMediaTrackingMessageReader(it))
        }
        result.success(null)
    }

    private fun onEndMediaTracking(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.endMediaTracking(EndMediaTrackingMessageReader(it))
        }
        result.success(null)
    }

    private fun onUpdateMediaTracking(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.updateMediaTracking(UpdateMediaTrackingMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdBreakEndEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdBreakEndEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdBreakStartEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdBreakStartEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdClickEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdClickEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdCompleteEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdCompleteEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdFirstQuartileEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdFirstQuartileEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdMidpointEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdMidpointEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdPauseEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdPauseEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdResumeEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdResumeEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdSkipEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdSkipEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdStartEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdStartEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaAdThirdQuartileEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaAdThirdQuartileEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaBufferEndEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaBufferEndEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaBufferStartEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaBufferStartEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaEndEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaEndEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaErrorEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaErrorEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaFullscreenChangeEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaFullscreenChangeEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaPauseEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaPauseEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaPictureInPictureChangeEvent(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaPictureInPictureChangeEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaPlayEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaPlayEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaPlaybackRateChangeEvent(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaPlaybackRateChangeEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaQualityChangeEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaQualityChangeEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaReadyEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaReadyEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaSeekEndEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaSeekEndEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaSeekStartEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaSeekStartEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackMediaVolumeChangeEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackMediaVolumeChangeEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackWebViewReaderEvent(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackWebViewReaderEvent(EventMessageReader(it))
        }
        result.success(null)
    }

    private fun onTrackPageView(call: MethodCall, result: MethodChannel.Result) {
        (call.arguments as? Map<String, Any>)?.let {
            SnowplowTrackerController.trackPageView(EventMessageReader(it))
        }
        result.success(null)
    }

}
