
#!/bin/sh

set -e

flutter drive --driver test_driver/integration_test.dart --target integration_test/configuration_test.dart $1
flutter drive --driver test_driver/integration_test.dart --target integration_test/events_test.dart $1
flutter drive --driver test_driver/integration_test.dart --target integration_test/session_test.dart $1
