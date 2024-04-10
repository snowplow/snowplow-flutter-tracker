/*!
 * Snowplow media tracking v3.23.0 (https://github.com/snowplow/snowplow-javascript-tracker)
 * Copyright 2022 Snowplow Analytics Ltd, 2010 Anthon Pang
 * Licensed under BSD-3-Clause
 */

"use strict";!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?t(exports):"function"==typeof define&&define.amd?define(["exports"],t):t((e="undefined"!=typeof globalThis?globalThis:e||self).snowplowMedia={})}(this,(function(e){function t(e,t,i){if(i||2===arguments.length)for(var n,a=0,o=t.length;a<o;a++)!n&&a in t||(n||(n=Array.prototype.slice.call(t,0,a)),n[a]=t[a]);return e.concat(n||Array.prototype.slice.call(t))}function i(e,t,i){try{var n=null!=e?e:Object.keys(t);e=[];for(var a=0;a<n.length;a++){var o=n[a];t.hasOwnProperty(o)?e.push(t[o]):p.warn(o+" not configured")}e.forEach(i)}catch(e){p.error("Function failed",e)}}function n(e){return"iglu:com.snowplowanalytics.snowplow.media/"+function(e){switch(e){case c.AdFirstQuartile:case c.AdMidpoint:case c.AdThirdQuartile:return"ad_quartile"}return e}(e)+"_event/jsonschema/1-0-0"}function a(e){var t,i={};for(t in e)null!=e[t]&&(i[t]=e[t]);return i}function o(e){if(void 0!==w[e])return w[e];p.error("Media tracking ".concat(e," not started."))}function r(e,t,n){void 0===n&&(n=Object.keys(S));var a=t.context,r=void 0===a?[]:a,s=t.timestamp;a=t.player;var d=t.ad,u=t.adBreak,c=e.mediaEvent;e=e.customEvent,void 0!==(t=o(t.id))&&(t.update((function(e){i(n,S,(function(t){var i,n=(t=t.core).track,a=e.event,o=a.schema,d=a.data;a=function(){var e,t={},i=[],n=[],a=[],o=function(e,i){null!=i&&""!==i&&(t[e]=i)};return{add:o,addDict:function(e){for(var t in e)Object.prototype.hasOwnProperty.call(e,t)&&o(t,e[t])},addJson:function(e,t,a){var o;if(o=a)e:{if(null!=a&&(a.constructor==={}.constructor||a.constructor===[].constructor))for(var r in a)if(Object.prototype.hasOwnProperty.call(a,r)){o=!0;break e}o=!1}o&&(e={keyIfEncoded:e,keyIfNotEncoded:t,json:a},n.push(e),i.push(e))},addContextEntity:function(e){a.push(e)},getPayload:function(){return t},getJson:function(){return i},withJsonProcessor:function(t){e=t},build:function(){return null==e||e(this,n,a),t}}}(),o={schema:"iglu:com.snowplowanalytics.snowplow/unstruct_event/jsonschema/1-0-0",data:{schema:o,data:d}},a.add("e","ue"),a.addJson("ue_px","ue_pr",o),n.call(t,a,(null!==(i=e.context)&&void 0!==i?i:[]).concat(r),s)}))}),c,e,a,d,u),t.shouldUpdatePageActivity()&&i(n,S,(function(e){e.updatePageActivity()})))}var s,d,u=function(){return u=Object.assign||function(e){for(var t,i=1,n=arguments.length;i<n;i++)for(var a in t=arguments[i])Object.prototype.hasOwnProperty.call(t,a)&&(e[a]=t[a]);return e},u.apply(this,arguments)};(d=s||(s={}))[d.none=0]="none",d[d.error=1]="error",d[d.warn=2]="warn",d[d.debug=3]="debug",d[d.info=4]="info";var c,l,p=function(e){return void 0===e&&(e=s.warn),{setLogLevel:function(t){e=s[t]?t:s.warn},warn:function(i,n){for(var a=[],o=2;o<arguments.length;o++)a[o-2]=arguments[o];e>=s.warn&&"undefined"!=typeof console&&(o="Snowplow: "+i,n?console.warn.apply(console,t([o+"\n",n],a,!1)):console.warn.apply(console,t([o],a,!1)))},error:function(i,n){for(var a=[],o=2;o<arguments.length;o++)a[o-2]=arguments[o];e>=s.error&&"undefined"!=typeof console&&(o="Snowplow: "+i+"\n",n?console.error.apply(console,t([o+"\n",n],a,!1)):console.error.apply(console,t([o],a,!1)))},debug:function(i){for(var n=[],a=1;a<arguments.length;a++)n[a-1]=arguments[a];e>=s.debug&&"undefined"!=typeof console&&console.debug.apply(console,t(["Snowplow: "+i],n,!1))},info:function(i){for(var n=[],a=1;a<arguments.length;a++)n[a-1]=arguments[a];e>=s.info&&"undefined"!=typeof console&&console.info.apply(console,t(["Snowplow: "+i],n,!1))}}}();!function(e){e.Ready="ready",e.Play="play",e.Pause="pause",e.End="end",e.SeekStart="seek_start",e.SeekEnd="seek_end",e.PlaybackRateChange="playback_rate_change",e.VolumeChange="volume_change",e.FullscreenChange="fullscreen_change",e.PictureInPictureChange="picture_in_picture_change",e.Ping="ping",e.PercentProgress="percent_progress",e.AdBreakStart="ad_break_start",e.AdBreakEnd="ad_break_end",e.AdStart="ad_start",e.AdFirstQuartile="ad_first_quartile",e.AdMidpoint="ad_midpoint",e.AdThirdQuartile="ad_third_quartile",e.AdComplete="ad_complete",e.AdSkip="ad_skip",e.AdClick="ad_click",e.AdPause="ad_pause",e.AdResume="ad_resume",e.BufferStart="buffer_start",e.BufferEnd="buffer_end",e.QualityChange="quality_change",e.Error="error"}(c||(c={})),function(e){e.Audio="audio",e.Video="video"}(l||(l={})),e.MediaPlayerAdBreakType=void 0,function(e){e.Linear="linear",e.NonLinear="nonlinear",e.Companion="companion"}(e.MediaPlayerAdBreakType||(e.MediaPlayerAdBreakType={}));var h=function(){function e(){this.podPosition=0}return e.prototype.updateForThisEvent=function(e,t,i,n){e==c.AdStart?(this.ad=void 0,this.podPosition++):e==c.AdBreakStart&&(this.adBreak=void 0,this.podPosition=0),void 0!==i&&(e={podPosition:0<this.podPosition?this.podPosition:void 0},this.ad=void 0!==this.ad?u(u(u({},this.ad),e),i):u(u({},e),i)),void 0!==n&&(t={startTime:t.currentTime},this.adBreak=void 0!==this.adBreak?u(u(u({},t),this.adBreak),n):u(u({},t),n))},e.prototype.updateForNextEvent=function(e){e==c.AdBreakEnd&&(this.adBreak=void 0,this.podPosition=0),e!=c.AdComplete&&e!=c.AdSkip||(this.ad=void 0)},e.prototype.getContext=function(){var e=[];return void 0!==this.ad&&e.push({schema:"iglu:com.snowplowanalytics.snowplow.media/ad/jsonschema/1-0-0",data:a(this.ad)}),void 0!==this.adBreak&&e.push({schema:"iglu:com.snowplowanalytics.snowplow.media/ad_break/jsonschema/1-0-0",data:a(this.adBreak)}),e},e}(),v=function(){function e(e){var t,i=this;this.aggregateEventsWithOrder={},this.eventsToAggregate={};var a=void 0===e||!0===e;(a||"object"==typeof e&&!1!==e.seekEvents)&&(this.aggregateEventsWithOrder[n(c.SeekStart)]=!0,this.aggregateEventsWithOrder[n(c.SeekEnd)]=!1),(a||"object"==typeof e&&!1!==e.volumeChangeEvents)&&(this.aggregateEventsWithOrder[n(c.VolumeChange)]=!1),this.flushTimeoutMs=null!==(t="object"==typeof e?e.flushTimeoutMs:void 0)&&void 0!==t?t:5e3,Object.keys(this.aggregateEventsWithOrder).forEach((function(e){i.eventsToAggregate[e]=[]}))}return e.prototype.trackFilteredEvents=function(e,t){var i=this,n=!1;e.forEach((function(e){var a=e.event,o=e.context;void 0!==i.eventsToAggregate[a.schema]?(n=!0,i.eventsToAggregate[a.schema].push((function(){return t({event:a,context:o})}))):(n=!1,i.flush(),t({event:a,context:o}))})),n&&void 0===this.flushTimeout&&this.setFlushTimeout()},e.prototype.flush=function(){var e=this;this.clearFlushTimeout(),Object.keys(this.eventsToAggregate).forEach((function(t){var i=e.eventsToAggregate[t];0<i.length&&(e.aggregateEventsWithOrder[t]?i[0]():i[i.length-1](),e.eventsToAggregate[t]=[])}))},e.prototype.clearFlushTimeout=function(){void 0!==this.flushTimeout&&(clearTimeout(this.flushTimeout),this.flushTimeout=void 0)},e.prototype.setFlushTimeout=function(){var e=this;this.clearFlushTimeout(),this.flushTimeout=window.setTimeout((function(){return e.flush()}),this.flushTimeoutMs)},e}(),y=function(){function e(e,t,i,n,a,o,r,s,d){this.sentBoundaries=[],this.player={currentTime:0,paused:!0,ended:!1},this.adTracking=new h,this.id=e,this.updatePlayer(t),this.session=i,this.pingInterval=n,this.boundaries=a,this.captureEvents=o,this.updatePageActivityWhilePlaying=r,this.customContext=d,this.repeatedEventFilter=new v(s),null==o||o.forEach((function(e){Object.values(c).includes(e)||p.warn("Unknown media event "+e)}))}return e.prototype.flushAndStop=function(){var e;null===(e=this.pingInterval)||void 0===e||e.clear(),this.repeatedEventFilter.flush()},e.prototype.update=function(e,t,i,o,r,s){var d,u;this.updatePlayer(o),void 0!==t&&this.adTracking.updateForThisEvent(t.type,this.player,r,s),null===(d=this.session)||void 0===d||d.update(null==t?void 0:t.type,this.player,this.adTracking.adBreak),null===(u=this.pingInterval)||void 0===u||u.update(this.player);var l=[{schema:"iglu:com.snowplowanalytics.snowplow/media_player/jsonschema/2-0-0",data:a(this.player)}];void 0!==this.session&&l.push(this.session.getContext()),this.customContext&&(l=l.concat(this.customContext)),l=l.concat(this.adTracking.getContext()),o=[],void 0!==t&&this.shouldTrackEvent(t.type)&&o.push(t),this.shouldSendPercentProgress()&&o.push({type:c.PercentProgress,eventBody:{percentProgress:this.getPercentProgress()}}),void 0!==t&&this.adTracking.updateForNextEvent(t.type),t=o.map((function(e){var t;return{event:{schema:n(e.type),data:a(null!==(t=e.eventBody)&&void 0!==t?t:{})},context:l}})),void 0!==i&&t.push({event:i,context:l}),this.repeatedEventFilter.trackFilteredEvents(t,e)},e.prototype.shouldUpdatePageActivity=function(){var e;return(null===(e=this.updatePageActivityWhilePlaying)||void 0===e||e)&&!this.player.paused},e.prototype.updatePlayer=function(e){void 0!==e&&(this.player=u(u({},this.player),e))},e.prototype.shouldSendPercentProgress=function(){var e=this.getPercentProgress();if(void 0===this.boundaries||void 0===e||this.player.paused)return!1;var t=this.boundaries.filter((function(t){return t<=(null!=e?e:0)}));return 0!=t.length&&(t=Math.max.apply(Math,t),!this.sentBoundaries.includes(t)&&(this.sentBoundaries.push(t),!0))},e.prototype.shouldTrackEvent=function(e){return void 0===this.captureEvents||this.captureEvents.includes(e)},e.prototype.getPercentProgress=function(){var e;if(null!==this.player.duration&&void 0!==this.player.duration&&0!=this.player.duration)return Math.floor((null!==(e=this.player.currentTime)&&void 0!==e?e:0)/this.player.duration*100)},e}(),f=function(){function e(e,t,i){var n=this;this.numPausedPings=0,this.maxPausedPings=1,void 0!==t&&(this.maxPausedPings=t),this.interval=setInterval((function(){(!n.isPaused()||n.numPausedPings<n.maxPausedPings)&&(n.isPaused()&&n.numPausedPings++,i())}),1e3*(null!=e?e:30))}return e.prototype.update=function(e){this.paused=e.paused,this.paused||(this.numPausedPings=0)},e.prototype.clear=function(){void 0!==this.interval&&(clearInterval(this.interval),this.interval=void 0)},e.prototype.isPaused=function(){return!0===this.paused},e}(),g=[c.AdStart,c.AdResume],k=[c.AdClick,c.AdFirstQuartile,c.AdMidpoint,c.AdThirdQuartile],m=[c.AdComplete,c.AdSkip,c.AdPause],P=[c.BufferEnd,c.Play],b=function(){function e(){this.duration=this.durationWithPlaybackRate=0}return e.prototype.add=function(e,t){this.durationWithPlaybackRate+=e*t,this.duration+=t},e.prototype.get=function(){return 0<this.duration?this.durationWithPlaybackRate/this.duration:void 0},e}(),A=function(){function t(){this.playbackDurationMuted=this.playbackDuration=this.adPlaybackDuration=0,this.avgPlaybackRate=new b,this.bufferingDuration=this.adsClicked=this.adsSkipped=this.adBreaks=this.ads=this.pausedDuration=0,this.playedSeconds=new Set}return t.prototype.update=function(t,i,n){var a;t={time:(new Date).getTime()/1e3,contentTime:i.currentTime,eventType:t,playbackRate:i.playbackRate,paused:i.paused,muted:i.muted,linearAd:(null!==(a=null==n?void 0:n.breakType)&&void 0!==a?a:e.MediaPlayerAdBreakType.Linear)==e.MediaPlayerAdBreakType.Linear},this.updateDurationStats(t),this.updateAdStats(t),this.updateBufferingStats(t),this.lastLog=t},t.prototype.toSessionContextEntity=function(){return{timePaused:0<this.pausedDuration?this.round(this.pausedDuration):void 0,timePlayed:0<this.playbackDuration?this.round(this.playbackDuration):void 0,timePlayedMuted:0<this.playbackDurationMuted?this.round(this.playbackDurationMuted):void 0,timeSpentAds:0<this.adPlaybackDuration?this.round(this.adPlaybackDuration):void 0,timeBuffering:0<this.bufferingDuration?this.round(this.bufferingDuration):void 0,ads:0<this.ads?this.ads:void 0,adBreaks:0<this.adBreaks?this.adBreaks:void 0,adsSkipped:0<this.adsSkipped?this.adsSkipped:void 0,adsClicked:0<this.adsClicked?this.adsClicked:void 0,avgPlaybackRate:this.round(this.avgPlaybackRate.get()),contentWatched:0<this.playedSeconds.size?this.playedSeconds.size:void 0}},t.prototype.updateDurationStats=function(e){var t;if(null===(t=void 0===this.lastAdUpdateAt||!e.linearAd)||void 0===t||t){if(void 0!==this.lastLog)if(t=e.time-this.lastLog.time,this.lastLog.paused)this.pausedDuration+=t;else if(this.playbackDuration+=t,void 0!==this.lastLog.playbackRate&&this.avgPlaybackRate.add(this.lastLog.playbackRate,t),this.lastLog.muted&&(this.playbackDurationMuted+=t),!e.paused)for(t=Math.floor(this.lastLog.contentTime);t<e.contentTime;t++)this.playedSeconds.add(t);e.paused||this.playedSeconds.add(Math.floor(e.contentTime))}},t.prototype.updateAdStats=function(e){void 0!==e.eventType&&(e.eventType==c.AdBreakStart?this.adBreaks++:e.eventType==c.AdStart?this.ads++:e.eventType==c.AdSkip?this.adsSkipped++:e.eventType==c.AdClick&&this.adsClicked++,void 0===this.lastAdUpdateAt?g.includes(e.eventType)&&(this.lastAdUpdateAt=e.time):k.includes(e.eventType)?(this.adPlaybackDuration+=e.time-this.lastAdUpdateAt,this.lastAdUpdateAt=e.time):m.includes(e.eventType)&&(this.adPlaybackDuration+=e.time-this.lastAdUpdateAt,this.lastAdUpdateAt=void 0))},t.prototype.updateBufferingStats=function(e){e.eventType==c.BufferStart?(this.bufferingStartedAt=e.time,this.bufferingStartTime=e.contentTime):void 0!==this.bufferingStartedAt&&(e.contentTime!=this.bufferingStartTime&&!e.paused||void 0!==e.eventType&&P.includes(e.eventType)?(this.bufferingDuration+=e.time-this.bufferingStartedAt,this.bufferingStartTime=this.bufferingStartedAt=void 0):(this.bufferingDuration+=e.time-this.bufferingStartedAt,this.bufferingStartedAt=e.time))},t.prototype.round=function(e){if(void 0!==e)return Math.round(1e3*e)/1e3},t}(),E=function(){function e(e,t,i){this.stats=new A,this.id=e,this.pingInterval=i,this.startedAt=null!=t?t:new Date}return e.prototype.update=function(e,t,i){this.stats.update(e,t,i)},e.prototype.getContext=function(){return{schema:"iglu:com.snowplowanalytics.snowplow.media/session/jsonschema/1-0-0",data:a(u({mediaSessionId:this.id,startedAt:this.startedAt,pingInterval:this.pingInterval},this.stats.toSessionContextEntity()))}},e}(),S={},T={},w={};e.SnowplowMediaPlugin=function(){var e;return{activateBrowserPlugin:function(t){e=t.id,S[e]=t,T[e]=[]},contexts:function(){return T[e]||[]}}},e.endMediaTracking=function(e){w[e.id]&&(w[e.id].flushAndStop(),delete w[e.id])},e.startMediaTracking=function(e,t){var i,n,a;void 0===t&&(t=Object.keys(S));var o="boolean"==typeof e.pings||null===(i=e.pings)||void 0===i?void 0:i.pingInterval;i="boolean"==typeof e.pings||null===(n=e.pings)||void 0===n?void 0:n.maxPausedPings,n=!1===e.pings||void 0===e.pings?void 0:new f(o,i,(function(){r({mediaEvent:{type:c.Ping}},{id:e.id},t)})),o=!1===e.session?void 0:new E(e.id,null===(a=e.session)||void 0===a?void 0:a.startedAt,o),a=new y(e.id,e.player,o,n,e.boundaries,e.captureEvents,e.updatePageActivityWhilePlaying,e.filterOutRepeatedEvents,e.context),w[a.id]=a},e.trackMediaAdBreakEnd=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.AdBreakEnd}},e,t)},e.trackMediaAdBreakStart=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.AdBreakStart}},e,t)},e.trackMediaAdClick=function(e,t){void 0===t&&(t=Object.keys(S));var i=e.percentProgress;void 0!==i&&(i=Math.floor(i)),r({mediaEvent:{type:c.AdClick,eventBody:{percentProgress:i}}},e,t)},e.trackMediaAdComplete=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.AdComplete}},e,t)},e.trackMediaAdFirstQuartile=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.AdFirstQuartile,eventBody:{percentProgress:25}}},e,t)},e.trackMediaAdMidpoint=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.AdMidpoint,eventBody:{percentProgress:50}}},e,t)},e.trackMediaAdPause=function(e,t){void 0===t&&(t=Object.keys(S));var i=e.percentProgress;void 0!==i&&(i=Math.floor(i)),r({mediaEvent:{type:c.AdPause,eventBody:{percentProgress:i}}},e,t)},e.trackMediaAdResume=function(e,t){void 0===t&&(t=Object.keys(S));var i=e.percentProgress;void 0!==i&&(i=Math.floor(i)),r({mediaEvent:{type:c.AdResume,eventBody:{percentProgress:i}}},e,t)},e.trackMediaAdSkip=function(e,t){void 0===t&&(t=Object.keys(S));var i=e.percentProgress;void 0!==i&&(i=Math.floor(i)),r({mediaEvent:{type:c.AdSkip,eventBody:{percentProgress:i}}},e,t)},e.trackMediaAdStart=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.AdStart}},e,t)},e.trackMediaAdThirdQuartile=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.AdThirdQuartile,eventBody:{percentProgress:75}}},e,t)},e.trackMediaBufferEnd=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.BufferEnd}},e,t)},e.trackMediaBufferStart=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.BufferStart}},e,t)},e.trackMediaEnd=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.End}},u(u({},e),{player:u(u({},e.player),{ended:!0,paused:!0})}),t)},e.trackMediaError=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.Error,eventBody:{errorCode:e.errorCode,errorName:e.errorName,errorDescription:e.errorDescription}}},e,t)},e.trackMediaFullscreenChange=function(e,t){void 0===t&&(t=Object.keys(S));var i=e.fullscreen;r({mediaEvent:{type:c.FullscreenChange,eventBody:{fullscreen:i}}},u(u({},e),{player:u(u({},e.player),{fullscreen:i})}),t)},e.trackMediaPause=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.Pause}},u(u({},e),{player:u(u({},e.player),{paused:!0})}),t)},e.trackMediaPictureInPictureChange=function(e,t){void 0===t&&(t=Object.keys(S));var i=e.pictureInPicture;r({mediaEvent:{type:c.PictureInPictureChange,eventBody:{pictureInPicture:i}}},u(u({},e),{player:u(u({},e.player),{pictureInPicture:i})}),t)},e.trackMediaPlay=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.Play}},u(u({},e),{player:u(u({},e.player),{paused:!1})}),t)},e.trackMediaPlaybackRateChange=function(e,t){var i;void 0===t&&(t=Object.keys(S));var n=e.previousRate,a=e.newRate;r({mediaEvent:{type:c.PlaybackRateChange,eventBody:{previousRate:null!=n?n:null===(i=o(e.id))||void 0===i?void 0:i.player.playbackRate,newRate:a}}},u(u({},e),{player:u(u({},e.player),{playbackRate:a})}),t)},e.trackMediaQualityChange=function(e,t){var i;void 0===t&&(t=Object.keys(S));var n=e.previousQuality,a=e.newQuality,s=e.bitrate,d=e.framesPerSecond,l=e.automatic,p=e.id;r({mediaEvent:{type:c.QualityChange,eventBody:{previousQuality:null!=n?n:null===(i=o(p))||void 0===i?void 0:i.player.quality,newQuality:a,bitrate:s,framesPerSecond:d,automatic:l}}},u(u({},e),{player:u(u({},e.player),{quality:a})}),t)},e.trackMediaReady=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.Ready}},e,t)},e.trackMediaSeekEnd=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.SeekEnd}},e,t)},e.trackMediaSeekStart=function(e,t){void 0===t&&(t=Object.keys(S)),r({mediaEvent:{type:c.SeekStart}},e,t)},e.trackMediaSelfDescribingEvent=function(e,t){void 0===t&&(t=Object.keys(S)),r({customEvent:e.event},e,t)},e.trackMediaVolumeChange=function(e,t){var i;void 0===t&&(t=Object.keys(S));var n=e.previousVolume,a=e.newVolume;r({mediaEvent:{type:c.VolumeChange,eventBody:{previousVolume:null!=n?n:null===(i=o(e.id))||void 0===i?void 0:i.player.volume,newVolume:a}}},u(u({},e),{player:u(u({},e.player),{volume:a})}),t)},e.updateMediaTracking=function(e,t){void 0===t&&(t=Object.keys(S)),r({},e,t)},Object.defineProperty(e,"__esModule",{value:!0})}));
//# sourceMappingURL=index.umd.min.js.map
