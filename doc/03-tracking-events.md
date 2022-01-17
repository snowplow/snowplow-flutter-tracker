# Tracking events

Snowplow has been built to enable you to track a wide range of events that occur when users interact with your apps.

We provide several built-in event classes to help you track different kinds of events. When instantiated, their objects can be passed to the `Snowplow.track()` method to send events to the Snowplow collector. The event classes range from single purpose ones, such as `ScreenView`, to the more complex but flexible `SelfDescribing`, which can be used to track any kind of user behaviour. We strongly recommend using `SelfDescribing` for your tracking, as it allows you to design custom event types to match your business requirements. [This post](https://snowplowanalytics.com/blog/2020/01/24/re-thinking-the-structure-of-event-data/) on our blog, "Re-thinking the structure of event data" might be informative here.

Event classes supported by the Flutter Tracker:

| Method | Event type tracked |
|---|---|
| `SelfDescribing` | Custom event based on "self-describing" JSON schema |
| `Structured` | Semi-custom structured event |
| `ScreenView` | View of a screen in the app |
| `Timing` | User timing events such as how long resources take to load. |
| `ConsentGranted` | User opting into data collection. |
| `ConsentWithdrawn` | User withdrawing consent for data collection. |

All the methods share common features and parameters. Every type of event can have an optional context added. See the [next page](04-adding-data.md) to learn about adding extra data to events. It's important to understand how event context works, as it is one of the most powerful Snowplow features. Adding event context is a way to add depth, richness and value to all of your events.

Snowplow events are all processed into the same format, regardless of the event type (and regardless of the tracker language used). Read about the different properties and fields of events in the [Snowplow Tracker Protocol](https://docs.snowplowanalytics.com/docs/collecting-data/collecting-from-own-applications/snowplow-tracker-protocol/).

We will first discuss the custom event types, followed by the out-of-the-box event types. Note that you can also design and create your own page view, or screen view, using `selfDescribing`, to fit your business needs better. The out-of-the-box event types are provided so you can get started with generating event data quickly.

## Track self-describing events with `SelfDescribing`

Use the `SelfDescribing` type to track a custom event. This is the most advanced and powerful tracking method, which requires a certain amount of planning and infrastructure.

Self-describing events are based around "self-describing" (self-referential) JSONs, which are a specific kind of [JSON schema](http://json-schema.org/). A unique schema can be designed for each type of event that you want to track. This allows you to track the specific things that are important to you, in a way that is defined by you.

This is particularly useful when:

- You want to track event types which are proprietary/specific to your business
- You want to track events which have unpredictable or frequently changing properties

A self-describing JSON has two keys, `schema` and `data`. The `schema` value should point to a valid self-describing JSON schema. They are called self-describing because the schema will specify the fields allowed in the data value. Read more about how schemas are used with Snowplow [here](https://docs.snowplowanalytics.com/docs/understanding-tracking-design/understanding-schemas-and-validation/).

After events have been collected by the event collector, they are validated to ensure that the properties match the self-describing JSONs. Mistakes (e.g. extra fields, or incorrect types) will result in events being processed as Bad Events. This means that only high-quality, valid events arrive in your data storage or real-time stream.

Your schemas must be accessible to your pipeline to allow this validation. We provide [Iglu](https://docs.snowplowanalytics.com/docs/pipeline-components-and-applications/iglu/) for schema management. If you are a paid Snowplow customer, you can manage your schemas through your console. Check out our [Ruby tracker Rails](https://github.com/snowplow-incubator/snowplow-ruby-tracker-examples) example to see how we included schemas in the Snowplow Micro testing pipeline in that app.

Creating an instance of `SelfDescribing` takes a schema name and a dictionary of event data.

Example (assumes that `tracker` is a tracker instance created using `Snowplow.createTracker`):

```dart
tracker.track(SelfDescribing(
    schema: 'iglu:com.example_company/save_game/jsonschema/1-0-2',
    data: {
        'saveId': '4321',
        'level': 23,
        'difficultyLevel': 'HARD',
        'dlContent': true
    }
));
```

## Track structured events with `Structured`

This method provides a halfway-house between tracking fully user-defined self-describing events and out-of-the box predefined events. This event type can be used to track many types of user activity, as it is somewhat customizable. "Struct" events closely mirror the structure of Google Analytics events, with "category", "action", "label", and "value" properties.

As these fields are fairly arbitrary, we recommend following the advice in this table how to define structured events. It's important to be consistent throughout the business about how each field is used.

| Argument   | Description                                                    | Required in event? |
| -----------| -------------------------------------------------------------- | ------------------ |
| `category` | The grouping of structured events which this action belongs to | Yes                |
| `action`   | Defines the type of user interaction which this event involves | Yes                |
| `label`    | Often used to refer to the 'object' the action is performed on | No                 |
| `property` | Describing the 'object', or the action performed on it         | No                 |
| `value`    | Provides numerical data about the event                        | No                 |

Example:

```dart
tracker.track(Structured(
    category: 'shop',
    action: 'add-to-basket',
    label: 'Add To Basket',
    property: 'pcs',
    value: 2.00,
));
```

## Track screen views with `ScreenView`

Use `ScreenView` to track a user viewing a screen (or similar) within your app. This is the page view equivalent for apps that are not webpages (the Flutter tracker follows the [Snowplow mobile data model](https://docs.snowplowanalytics.com/docs/modeling-your-data/the-snowplow-mobile-model/) and uses them also on the Web). The arguments are `name`, `id`, `type`, and `transitionType`. The `name` and `id` properties are required. "Name" is the human-readable screen name, and "ID" should be the unique screen ID (UUID v4).

This method creates an unstruct event, by creating and tracking a self-describing event. The schema ID for this is "iglu:com.snowplowanalytics.snowplow/screen_view/jsonschema/1-0-0", and the data field will contain the parameters which you provide. That schema is hosted on the schema repository Iglu Central, and so will always be available to your pipeline.

| Argument | Description | Required in event? |
|---|---|---|
| `name` | The name of the screen viewed. | Yes |
| `id` | The id (UUID v4) of screen that was viewed. | Yes |
| `type` | The type of screen that was viewed. | No |
| `previousName` | The name of the previous screen that was viewed. | No |
| `previousType` | The type of screen that was viewed. | No |
| `previousId` | The id (UUID v4) of the previous screen that was viewed. | No |
| `transitionType` | The type of transition that led to the screen being viewed. | No |

Example:

```dart
tracker.track(ScreenView(
    id: '2c295365-eae9-4243-a3ee-5c4b7baccc8f',
    name: 'home',
    type: 'full',
    transitionType: 'none'));
```

## Track timing events with `Timing`

Use the `Timing` type to track user timing events such as how long resources take to load. These events take a timing `category`, the `variable` being measured, and the `timing` time measurement. An optional `label` can be added to further identify the timing event

| Argument | Description | Required in event? |
|---|---|---|
| `category` | Defines the timing category. | Yes |
| `variable` | Defines the timing variable measured. | Yes |
| `timing` | Represents the time. | Yes |
| `label` | An optional string to further identify the timing event. | No |

Example:

```dart
tracker.track(Timing(
    category: 'category',
    variable: 'variable',
    timing: 1,
    label: 'label',
));
```

## Track user consent with `ConsentGranted` and `ConsentWithdrawn`

Use the `ConsentGranted` to track a user opting into data collection and `ConsentWithdrawn` to track a user withdrawing their consent for data collection.

For both events, a consent document context will be attached to the event using the `documentId` and `version` arguments supplied. To specify that a user opts out of all data collection using the `ConsentWithdrawn` event, the `all` property should be set to true.

Properties of `ConsentGranted`:

| Argument | Description | Required in event? |
|---|---|---|
| `expiry` | The expiry date-time of the consent. | Yes |
| `documentId` | The consent document ID. | Yes |
| `version` | The consent document version. | Yes |
| `name` | Optional consent document name. | No |
| `documentDescription` | Optional consent document description. | No |

Example:

```dart
tracker.track(ConsentGranted(
    expiry: DateTime.now(),
    documentId: '1234',
    version: '5',
    name: 'name1',
    documentDescription: 'description1',
));
```

Properties of `ConsentWithdrawn`:

| Argument | Description | Required in event? |
|---|---|---|
| `all` | Whether user opts out of all data collection. | Yes |
| `documentId` | The consent document ID. | Yes |
| `version` | The consent document version. | Yes |
| `name` | Optional consent document name. | No |
| `documentDescription` | Optional consent document description. | No |

Example:

```dart
tracker.track(ConsentWithdrawn(
    all: false,
    documentId: '1234',
    version: '5',
    name: 'name1',
    documentDescription: 'description1',
));
```