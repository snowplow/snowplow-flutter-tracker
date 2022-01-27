# Initialization and configuration

The package provides a single method to initialize and configure a new tracker, the `Snowplow.createTracker` method. It accepts configuration parameters for the tracker and returns a `Tracker` instance.

```dart
Tracker tracker = await Snowplow.createTracker(
    namespace: 'ns1',
    endpoint: 'http://...',
    method: Method.post,
    trackerConfig: const TrackerConfiguration(...),
    gdprConfig: const GdprConfiguration(...),
    subjectConfig: const SubjectConfiguration(...));
);
```

The method returns a `Tracker` instance. This can be later used for tracking events, or accessing tracker properties. However, all methods provided by the `Tracker` instance are also available as static functions in the `Snowplow` class but they require passing the tracker namespace as string.

The only required attributes of the `Snowplow.createTracker` method are `namespace` used to identify the tracker, and the Snowplow collector `endpoint`. Additionally, one can configure the HTTP method to be used when sending events to the collector and provide configuration by instantiating classes for `TrackerConfiguration`, `SubjectConfiguration`, or `GdprConfiguration`. The following arguments are accepted by the `Snowplow.createTracker` method:

| Attribute | Type | Description |
|---|---|---|
| `namespace` | `String` | Tracker namespace to identify the tracker. |
| `endpoint` | `String` | URI for the Snowplow collector endpoint. |
| `method` | `Method?` | HTTP method to use. `Method.get` and `Method.post` options are available. |
| `trackerConfig` | `TrackerConfiguration?` | Configuration of the tracker and the core tracker properties. |
| `gdprConfig` | `GdprConfiguration?` | Determines the GDPR context that will be attached to all events sent by the tracker. |
| `subjectConfig` | `SubjectConfiguration?` | Subject information about tracked user and device that is added to events. |

## Configuration of tracker properties: `TrackerConfiguration`

`TrackerConfiguration` provides options to configure properties and features of the tracker. In addition to setting the app identifier and device platform, the configuration enables turning several automatic context entities on and off.

| Attribute | Type | Description | Android | iOS | Web | Default |
|---|---|---|---|---|---|---|
| `appId` | `String?` | Identifier of the app. | ✔ | ✔ | ✔ | null on Web, bundle identifier on iOS/Android |
| `devicePlatform` | `DevicePlatform?` | The device platform the tracker runs on. Available options are provided by the `DevicePlatform` enum. | ✔ | ✔ | ✔ | "web" on Web, "mob" on iOS/Android |
| `base64Encoding` | `bool?` | Indicates whether payload JSON data should be base64 encoded. | ✔ | ✔ | ✔ | true |
| `platformContext` | `bool?` | Indicates whether platform context should be attached to tracked events. | ✔ | ✔ | | true |
| `geoLocationContext` | `bool?` | Indicates whether geo-location context should be attached to tracked events. | ✔ | ✔ | ✔ | false |
| `sessionContext` | `bool?` | Indicates whether session context should be attached to tracked events. | ✔ | ✔ | ✔ | true |
| `webPageContext` | `bool?` | Indicates whether context about current web page should be attached to tracked events. | | | ✔ | true |
| `activityTrackingConfig` | ActivityTrackingConfiguration?` | Enables activity tracking using page pings on the Web. | | | ✔ | true |

## Configuration of subject information: `SubjectConfiguration`

Subject information are persistent and global information about the tracked device or user. They apply to all events and are assigned as event properties.

Some of the properties are only configurable on iOS and Android and are automatically assigned on the Web.

| Attribute | Type | Description | Android | iOS | Web | Default |
|---|---|---|---|---|---|---|
| `userId` | `String?` | Business ID of the user. | ✔ | ✔ | ✔ | |
| `networkUserId` | `String?` | Network user ID (UUIDv4). | ✔ | ✔ | Non-configurable, auto-assigned. | |
| `domainUserId` | `String?` | Domain user ID (UUIDv4). | ✔ | ✔ | Non-configurable, auto-assigned. | |
| `userAgent` | `String?` | Custom user-agent. It overrides the user-agent used by default. | ✔ | ✔ | Non-configurable, auto-assigned. | |
| `timezone` | `String?` | The timezone label. | ✔ | ✔ | Non-configurable, auto-assigned. | |
| `language` | `String?` | The language set on the device. | ✔ | ✔ | Non-configurable, auto-assigned. | |
| `screenResolution` | `Size?` | The screen resolution on the device. | ✔ | ✔ | Non-configurable, auto-assigned. | |
| `screenViewport` | `Size?` | The screen viewport. | ✔ | ✔ | Non-configurable, auto-assigned. | |
| `colorDepth` | `double?` | The color depth. | ✔ | ✔ | Non-configurable, auto-assigned. | |

The configured attributes are mapped to Snowplow event properties described in the [Snowplow Tracker Protocol](https://docs.snowplowanalytics.com/docs/collecting-data/collecting-from-own-applications/snowplow-tracker-protocol/). They are mapped as follows:

| Attribute | Event Property |
|---|---|
| `userId` | `uid` |
| `networkUserId` | `network_userid` |
| `domainUserId` | `domain_userid` |
| `userAgent` | `useragent` |
| `ipAddress` | `user_ipaddress` |
| `timezone` | `os_timezone` |
| `language` | `lang` |
| `screenResolution.width` | `dvce_screenwidth` |
| `screenResolution.height` | `dvce_screenheight` |
| `screenViewport.width` | `br_viewwidth` |
| `screenViewport.height` | `br_viewheight` |
| `colorDepth` | `br_colordepth` |

## GDPR context entity configuration: `GdprConfiguration`

Determines the GDPR context that will be attached to all events sent by the tracker.

| Attribute | Type | Description | Android | iOS | Web | Default |
|---|---|---|---|---|---|---|
| `basisForProcessing` | `String` | Basis for processing. | ✔ | ✔ | ✔ | |
| `documentId` | `String` | ID of a GDPR basis document. | ✔ | ✔ | ✔ | |
| `documentVersion` | `String` | Version of the document. | ✔ | ✔ | ✔ | |
| `documentDescription` | `String` | Description of the document. | ✔ | ✔ | ✔ | |
