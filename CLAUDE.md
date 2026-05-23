# CLAUDE.md - Snowplow Flutter Tracker Documentation

## Project Overview

The Snowplow Flutter Tracker is a cross-platform analytics SDK that enables Flutter applications to send events to Snowplow collectors. It wraps native iOS, Android, and JavaScript trackers to provide a unified Flutter API for comprehensive event tracking and analytics.

**Core Technologies:**
- Flutter/Dart for cross-platform API
- Platform channels for native communication
- Kotlin for Android implementation
- Swift for iOS implementation
- JavaScript interop for Web support

## Development Commands

```bash
# Build and run
flutter pub get                           # Install dependencies
flutter analyze                           # Run static analysis
flutter test                             # Run unit tests
flutter run --dart-define=ENDPOINT=http://localhost:9090  # Run example app

# Integration testing
cd example && flutter test integration_test --dart-define=ENDPOINT=http://192.168.0.20:9090

# Format code
dart format lib test example/lib

# Check package score
flutter pub publish --dry-run
```

## Architecture

### System Design

The tracker follows a **Plugin Architecture** with platform-specific implementations:

```
┌─────────────────────────────────────────┐
│         Flutter/Dart API Layer          │
│    (lib/snowplow.dart, tracker.dart)    │
└─────────────┬───────────────────────────┘
              │ MethodChannel
    ┌─────────┴──────────┬──────────────┐
    ▼                    ▼              ▼
┌──────────┐      ┌──────────┐   ┌──────────┐
│ Android  │      │   iOS    │   │   Web    │
│  (Kotlin)│      │ (Swift)  │   │   (JS)   │
└──────────┘      └──────────┘   └──────────┘
```

### Module Organization

- **`lib/`**: Core Flutter/Dart API
  - **`configurations/`**: Configuration classes for tracker setup
  - **`events/`**: Event type definitions
  - **`entities/`**: Data entities (media tracking)
  - **`src/web/`**: Web-specific implementations
- **`android/`**: Android platform implementation
- **`ios/`**: iOS platform implementation
- **`example/`**: Demo application and integration tests
- **`test/`**: Unit tests

## Core Architectural Principles

### 1. Immutable Event Pattern
All events and configurations are immutable with `@immutable` annotation:
```dart
// ✅ Correct: Immutable event
@immutable
class ScreenView implements Event {
  final String name;
  const ScreenView({required this.name});
}

// ❌ Wrong: Mutable event
class ScreenView implements Event {
  String name; // Mutable field
}
```

### 2. Platform Channel Communication
Use consistent message passing through MethodChannel:
```dart
// ✅ Correct: Clean method channel usage
await _channel.invokeMethod('trackScreenView', event.toMap());

// ❌ Wrong: Direct platform access
// Attempting to bypass the channel abstraction
```

### 3. Null-Safe Map Serialization
Always remove null values from serialization maps:
```dart
// ✅ Correct: Remove null values
Map<String, Object?> toMap() {
  final map = {'field': value};
  map.removeWhere((key, value) => value == null);
  return map;
}

// ❌ Wrong: Including null values
Map<String, Object?> toMap() => {'field': value}; // May include nulls
```

### 4. Factory Constructor Pattern for Deserialization
Use named factory constructors for map deserialization:
```dart
// ✅ Correct: Factory constructor
ScreenView.fromMap(Map<String, Object?> map)
    : name = map['name'] as String;

// ❌ Wrong: Static method
static ScreenView fromMap(Map map) { } // Inconsistent pattern
```

## Layer Organization & Responsibilities

### API Layer (lib/)
- **Responsibility**: Public Flutter API, event definitions, configurations
- **Key Classes**: `Snowplow`, `SnowplowTracker`, `Event` implementations
- **Pattern**: Immutable data classes with `toMap()` serialization

### Platform Layer (android/, ios/, web/)
- **Responsibility**: Native implementation and platform-specific features
- **Key Classes**: `SnowplowTrackerPlugin`, platform readers
- **Pattern**: Message readers for deserialization, controller for business logic

### Configuration Layer
- **Responsibility**: Tracker initialization and feature configuration
- **Key Classes**: `Configuration`, `TrackerConfiguration`, `NetworkConfiguration`
- **Pattern**: Builder-like immutable configuration objects

## Critical Import Patterns

### Event Imports
```dart
// ✅ Correct: Import from snowplow_tracker package
import 'package:snowplow_tracker/snowplow_tracker.dart';
import 'package:snowplow_tracker/events/screen_view.dart';

// ❌ Wrong: Direct file imports
import '../events/screen_view.dart'; // Use package imports
```

### Platform-Specific Code
```dart
// ✅ Correct: Use kIsWeb for platform checks
import 'package:flutter/foundation.dart';
if (kIsWeb) { /* web specific */ }

// ❌ Wrong: Using Platform.isAndroid on web
import 'dart:io';
if (Platform.isAndroid) { } // Crashes on web
```

## Essential Library Patterns

### Tracker Initialization
```dart
// ✅ Correct: Comprehensive tracker setup
final tracker = await Snowplow.createTracker(
  namespace: 'ns1',
  endpoint: 'https://collector.example.com',
  trackerConfig: TrackerConfiguration(appId: 'app'),
);

// ❌ Wrong: Missing required configuration
final tracker = await Snowplow.createTracker(); // Missing params
```

### Event Tracking
```dart
// ✅ Correct: Track with contexts
await tracker.track(
  ScreenView(name: 'home'),
  contexts: [SelfDescribing(schema: 'iglu:...', data: {})],
);

// ❌ Wrong: Incorrect event structure
await tracker.track({'type': 'screen'}); // Not an Event object
```

### Media Tracking
```dart
// ✅ Correct: Start media tracking with configuration
final media = await tracker.startMediaTracking(
  MediaTrackingConfiguration(id: 'video-1'),
);

// ❌ Wrong: Missing required ID
final media = await tracker.startMediaTracking(
  MediaTrackingConfiguration(), // Missing id
);
```

## Model Organization Pattern

### Event Hierarchy
```dart
abstract class Event {
  String endpoint();
  Map<String, Object?> toMap();
}

// Concrete implementations
class ScreenView implements Event { }
class Structured implements Event { }
class SelfDescribing implements Event { }
```

### Configuration Pattern
```dart
@immutable
class Configuration {
  final String namespace;
  final NetworkConfiguration networkConfig;
  // Optional configs
  final TrackerConfiguration? trackerConfig;
  
  Map<String, Object?> toMap() {
    // Serialize and remove nulls
  }
}
```

## Common Pitfalls & Solutions

### 1. WebView Integration
```dart
// ❌ Wrong: Forgetting to register JavaScript channel
webView.loadUrl('https://example.com');

// ✅ Correct: Register channel before loading
tracker.registerWebViewJavaScriptChannel(
  webViewController: controller,
);
webView.loadUrl('https://example.com');
```

### 2. Navigator Observer
```dart
// ❌ Wrong: Creating observer without tracker
MaterialApp(navigatorObservers: [SnowplowObserver()]);

// ✅ Correct: Use tracker's observer
MaterialApp(
  navigatorObservers: [tracker.getObserver()],
);
```

### 3. Platform Context Properties
```dart
// ❌ Wrong: Setting platform properties on Web
TrackerConfiguration(
  platformContextProperties: properties, // Not supported on Web
);

// ✅ Correct: Check platform first
TrackerConfiguration(
  platformContextProperties: kIsWeb ? null : properties,
);
```

### 4. Async Initialization
```dart
// ❌ Wrong: Not awaiting tracker creation
final tracker = Snowplow.createTracker(...); // Returns Future

// ✅ Correct: Await initialization
final tracker = await Snowplow.createTracker(...);
```

## File Structure Template

```
lib/
├── snowplow_tracker.dart         # Package exports
├── snowplow.dart                 # Main API class
├── tracker.dart                  # Tracker instance
├── configurations/
│   ├── configuration.dart        # Base configuration
│   ├── tracker_configuration.dart
│   └── network_configuration.dart
├── events/
│   ├── event.dart               # Event interface
│   ├── screen_view.dart
│   └── self_describing.dart
└── entities/
    └── media_player_entity.dart
```

## Testing Patterns

### Unit Test Structure
```dart
void main() {
  setUp(() async {
    // Mock method channel
    TestDefaultBinaryMessengerBinding.instance
        .defaultBinaryMessenger
        .setMockMethodCallHandler(channel, handler);
  });

  test('tracks event', () async {
    await tracker.track(ScreenView(name: 'test'));
    expect(capturedMethod, 'trackScreenView');
  });
}
```

### Integration Test Pattern
```dart
testWidgets('end-to-end tracking', (tester) async {
  final events = await getMicroEvents(endpoint);
  expect(events.any((e) => e['eventType'] == 'struct'), true);
});
```

## Quick Reference

### Event Type Checklist
- [ ] Implements `Event` interface
- [ ] Has `@immutable` annotation
- [ ] Implements `endpoint()` method
- [ ] Implements `toMap()` with null removal
- [ ] Has factory constructor `.fromMap()` for deserialization
- [ ] All fields are `final`

### Configuration Checklist
- [ ] All fields are `final` and nullable (optional)
- [ ] Has `toMap()` method with null removal
- [ ] Uses `@immutable` annotation
- [ ] Documents platform-specific features

### Platform Implementation Checklist
- [ ] Has reader class for deserialization
- [ ] Handles null values appropriately
- [ ] Maps to native tracker methods
- [ ] Consistent error handling

## Implementing tickets

When you're triggered by the `implement` label on a GitHub issue (or asked to implement an issue locally), the issue body is the spec — read it carefully before anything else.

Then:

1. Read this file. If the change is contained to one layer (Dart API, platform channels, Android/iOS/web bridges), match that layer's existing patterns before editing.
2. Implement the change as described in the issue body. Don't deviate from its file-level intent. If you find an error in it, note the deviation in the PR description.
3. Keep changes minimal and focused. Don't refactor unrelated code.
4. Add or modify tests for every new feature or bug fix.
5. If you discover a real architectural blocker the spec didn't anticipate, stop and post a comment on the issue. Don't guess.

Before opening the PR:

- `flutter analyze` — static analysis clean
- `flutter test` — unit tests pass
- `dart format lib test example/lib` — formatting consistent

PR shape (matches this repo's `CONTRIBUTING.md`):

- **Branch**: descriptive name (e.g. `fix/platform-channel-null-handling`).
- **Commits**: `Description (closes #1234)` — 1-to-1 with the issue.
- **PR title**: short, descriptive, with `(closes #1234)` referencing the issue.
- **PR body**: explain why the change is needed, not just what it is. Single feature/fix per PR.

## Contributing to CLAUDE.md

When adding or updating content in this document, please follow these guidelines:

### File Size Limit
- **CLAUDE.md must not exceed 40KB** (currently ~19KB)
- Check file size after updates: `wc -c CLAUDE.md`
- Remove outdated content if approaching the limit

### Code Examples
- Keep all code examples **4 lines or fewer**
- Focus on the essential pattern, not complete implementations
- Use `// ❌` and `// ✅` to clearly show wrong vs right approaches

### Content Organization
- Add new patterns to existing sections when possible
- Create new sections sparingly to maintain structure
- Update the architectural principles section for major changes
- Ensure examples follow current codebase conventions

### Quality Standards
- Test any new patterns in actual code before documenting
- Verify imports and syntax are correct for the codebase
- Keep language concise and actionable
- Focus on "what" and "how", minimize "why" explanations

### Multiple CLAUDE.md Files
- **Directory-specific CLAUDE.md files** can be created for specialized modules
- Follow the same structure and guidelines as this root CLAUDE.md
- Keep them focused on directory-specific patterns and conventions
- Maximum 20KB per directory-specific CLAUDE.md file

### Instructions for LLMs
When editing files in this repository, **always check for CLAUDE.md guidance**:

1. **Look for CLAUDE.md in the same directory** as the file being edited
2. **If not found, check parent directories** recursively up to project root
3. **Follow the patterns and conventions** described in the applicable CLAUDE.md
4. **Prioritize directory-specific guidance** over root-level guidance when conflicts exist