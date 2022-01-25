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

var plugin = {
    SessionContextPlugin: function () {
        return {

            getFirstEventId: function (sessionId, eventId) {
                if (typeof (Storage) !== "undefined") {
                    var storage = window.localStorage;
                    var stored = storage.getItem('spl_session');
                    if (stored) {
                        stored = JSON.parse(stored);
                        if (stored.sessionId == sessionId) {
                            return stored.eventId;
                        }
                    }
                    storage.setItem('spl_session', JSON.stringify({
                        sessionId: sessionId,
                        eventId: eventId
                    }));
                    return eventId;
                }
                return null;
            },

            beforeTrack: function (payloadBuilder) {
                var payload = payloadBuilder.build();

                var sessionUserId = payload['duid'];
                var sessionId = payload['sid'];
                var sessionIndex = parseInt(payload['vid']);
                var eventId = payload['eid'];

                if (!sessionUserId || !sessionId) { return; }

                var context = {
                    'schema': 'iglu:com.snowplowanalytics.snowplow/contexts/jsonschema/1-0-0',
                    'data': []
                };
                if (payload.cx) {
                    context = JSON.parse(atob(payload.cx));
                }
                var sessionContext = {
                    'schema': 'iglu:com.snowplowanalytics.snowplow/client_session/jsonschema/1-0-1',
                    'data': {
                        'userId': sessionUserId,
                        'sessionId': sessionId,
                        'sessionIndex': sessionIndex,
                        'previousSessionId': null,
                        'storageMechanism': 'COOKIE_1',
                        'firstEventId': this.getFirstEventId(sessionId, eventId)
                    }
                };
                context.data.push(sessionContext);

                payloadBuilder.addJson('cx', 'co', context);
            }
        };
    }
};

function addSessionContextPlugin(tracker) {
    window.snowplow('addPlugin:' + tracker, plugin, 'SessionContextPlugin');
}

function getSnowplowCookieParts(cookieName) {
    cookieName = cookieName || '_sp_';
    var matcher = new RegExp(cookieName + 'id\\.[a-f0-9]+=([^;]+);?');
    var match = document.cookie.match(matcher);
    if (match && match[1]) {
        return match[1].split('.');
    } else {
        return null;
    }
}

function getSnowplowSid(cookieName) { // session id
    var parts = getSnowplowCookieParts(cookieName);
    if (parts != null) {
        return parts[parts.length - 1];
    } else {
        return null;
    }
}

function getSnowplowVid(cookieName) { // session index
    var parts = getSnowplowCookieParts(cookieName);
    if (parts != null) {
        return parseInt(parts[2]);
    } else {
        return null;
    }
}

function getSnowplowDuid(cookieName) { // domain user id
    var parts = getSnowplowCookieParts(cookieName);
    if (parts != null) {
        return parts[0];
    } else {
        return null;
    }
}

function isSnowplowInstalled() {
    return window.snowplow != undefined;
}
