
#!/bin/sh

set -e

echo "== Running CI script on example app =="

# Grab packages.
flutter pub get

# Run the analyzer to find any static analysis issues.
flutter analyze

# Run the formatter on all the dart files to make sure everything's linted.
flutter format -n --set-exit-if-changed .

# Run the actual tests.
# flutter test

flutter drive --driver test_driver/integration_test.dart --target integration_test/configuration_test.dart -d $1
flutter drive --driver test_driver/integration_test.dart --target integration_test/events_test.dart -d $1
flutter drive --driver test_driver/integration_test.dart --target integration_test/session_test.dart -d $1
