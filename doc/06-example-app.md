# Example app with Snowplow tracking

The tracker comes with a demo app that shows it in use. It provides a number of buttons that fire different types of events.  The demo app may serve you to understand how to embed Snowplow tracking within a Flutter app.

The project in included in the [tracker repository](https://github.com/snowplow-incubator/snowplow-flutter-tracker), in the `example` subfolder. The following steps will help you set it up:

1. Download the [Flutter tracker project](https://github.com/snowplow-incubator/snowplow-flutter-tracker).
2. Run `npm install` within the project.
3. Install ropm `npm i ropm -g`.
4. Install ropm packages `ropm install`.
5. Create `.env` file with environment variables in the root of this repository.

    ```bash
    ROKU_IP=192.168.100.129
    ROKU_PASSWORD=XXXX
    ```

6. Add configuration for Snowplow collector to `src-demo-app/manifest`.

    ```bash
    snowplow_collector=http://192.168.100.127:9090
    snowplow_method=POST
    ```

7. Start the demo app using `npm run demo-app`.

Events will be sent to the Snowplow collector as you navigate through the app.
