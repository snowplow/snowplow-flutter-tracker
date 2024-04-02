
#!/bin/sh

set -e

flutter drive --driver test_driver/integration_test.dart --target integration_test/configuration_test.dart --dart-define=ENDPOINT=$1 $2
flutter drive --driver test_driver/integration_test.dart --target integration_test/events_test.dart --dart-define=ENDPOINT=$1 $2
flutter drive --driver test_driver/integration_test.dart --target integration_test/session_test.dart --dart-define=ENDPOINT=$1 $2
flutter drive --driver test_driver/integration_test.dart --target integration_test/media_test.dart --dart-define=ENDPOINT=$1 $2
