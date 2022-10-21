# Anonymous tracking

Anonymous tracking is a tracker feature that enables anonymising various user and session identifiers to support user privacy in case consent for tracking the identifiers is not given.

On mobile, the affected user and session identifiers are stored in two context entities: [Session](http://iglucentral.com/schemas/com.snowplowanalytics.snowplow/client_session/jsonschema/1-0-2) and [Platform context](http://iglucentral.com/schemas/com.snowplowanalytics.snowplow/mobile_context/jsonschema/1-0-2). The Session context entity contains user and session identifiers, while the Platform context entity contains user identifiers. 

On web, the affected user and session identifiers are stored in the cookies.

Concretely, the following user and session identifiers can be anonymised:

* Mobile client-side user identifiers: the `userId` in Session context entity and the IDFA identifiers (`appleIdfa` and `appleIdfv`, and their Android equivalents) in the Platform context entity.
* Mobile client-side session identifiers: `sessionId` in Session context entity.
* Web client-side user identifiers: the `domain_userid` in the sp_id cookie.
* Web client-side session identifiers: `sessionId` in Session context entity, `domain_sessionid`, and `domain_sessionidx` from the sp_id cookie.
* Server-side user identifiers: `network_userid` and `user_ipaddress` event properties.

There are several levels to the anonymisation depending on which of the three categories are affected:

## 1. Full client-side anonymisation

In this case, we want to anonymise both the client-side user identifiers as well as the client-side session identifiers.

On mobile, setting `userAnonymisation` affects properties in the Session and Platform entities. If neither is present, it has no effect. In the Platform context entity, the IDFA identifiers are anonymised. Here the Session entity is not configured: no session information will be tracked at all.

```dart
const TrackerConfiguration()
    .userAnonymisation(true)
    .sessionContext(false)
    .platformContext(true) // only relevant for mobile
```

On web, setting `userAnonymisation` stops any user identifiers or session information being stored in cookies or localStorage. This means that `domain_userid`, `domain_sessionid`, and `domain_sessionidx` will be anonymised. Again, no session information will be tracked at all.

```dart
const TrackerConfiguration().userAnonymisation(true)
```

## 2. Client-side anonymisation with session tracking

For mobile only, this setting disables client-side user identifiers but tracks session information.

```dart
const TrackerConfiguration()
    .userAnonymisation(true)
    .sessionContext(true)
    .platformContext(true)
```
On mobile, enabling both `userAnonymisation` and `sessionContext` means that events will have the Session context entity, but the `userId` property will be anonymised to a null UUID (`00000000-0000-0000-0000-000000000000`). As above, if the Platform context entity is enabled, the IDFA identifiers will not be present.

On web, enabling both `userAnonymisation` and `sessionContext` is the same as enabling just `userAnonymisation`; the Session entity is not added to events.

## 3. Server-side anonymisation

Server-side anonymisation affects user identifiers set server-side. In particular, these are the `network_userid` property set in server-side cookie and the user IP address (`user_ipaddress`). You can anonymise the properties using the `serverAnonymisation` flag in `EmitterConfiguration`:

```dart
const EmitterConfiguration()
    .serverAnonymisation(true)
```

Setting the flag will add a `SP-Anonymous` HTTP header to requests sent to the Snowplow collector. The Snowplow pipeline will take care of anonymising the identifiers.

On mobile, `serverAnonymisation` and `userAnonymisation` are separate. This means you can anonymise only the server-side identifiers without also anonymising the client-side identifiers.

On web, `serverAnonymisation` is effectively a subset of `userAnonymisation`. If `serverAnonymisation` is enabled, this will also set `userAnonymisation` to `true` (even if set to `false` in your `TrackerConfiguration`).
