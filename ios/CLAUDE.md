# iOS Platform Implementation Documentation

## Project Overview

The iOS platform implementation provides native Swift bindings for the Snowplow Flutter tracker, integrating with the native Snowplow iOS SDK. This layer handles method channel communication, Swift-Dart type conversion, and iOS-specific tracker configuration.

## Development Commands

```bash
# Run iOS tests
flutter test --platform ios

# Build iOS example app
cd example/ios && pod install
flutter build ios --no-codesign

# Clean iOS build
cd ios && rm -rf Pods .symlinks build
cd example/ios && pod deintegrate && pod install
```

## Architecture

### System Design

The iOS implementation follows a three-layer architecture mirroring the Android design:

1. **Plugin Layer** (`SnowplowTrackerPlugin.swift`): Method channel handler
2. **Controller Layer** (`SnowplowTrackerController.swift`): Business logic and native SDK integration
3. **Reader Layer** (`readers/`): Message deserialization from Dart types

### Core Components

- **Method Channel**: `snowplow_tracker` - handles Flutter-iOS communication
- **Message Readers**: Type-safe deserialization using Swift's `Decodable` protocol
- **Tracker Controller**: Singleton managing native Snowplow iOS SDK instances
- **Configuration Readers**: Convert Flutter configurations to native iOS SDK types

## Core Architectural Principles

### 1. Reader Pattern for Type Safety

All incoming messages use dedicated Reader structs with `Decodable`:

```swift
// ✅ Type-safe message reading
struct EventMessageReader: Decodable {
    let tracker: String
    let eventData: [String: Any]?
}
```

### 2. Consistent Method Channel Handling

Method calls follow a decode-process-respond pattern:

```swift
// ✅ Proper method channel handling
private func onTrackStructured(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if let (message, arguments): (TrackStructuredMessageReader, [String: Any]) = decodeCall(call) {
        SnowplowTrackerController.trackStructured(message, arguments: arguments)
    }
    result(nil)
}
```

### 3. Optional Handling with Swift Patterns

Use Swift's optional binding for nullable fields:

```swift
// ✅ Safe optional handling
if let trackerConfig = message.trackerConfig {
    controllers.append(trackerConfig.toConfiguration())
}
```

## Layer Organization & Responsibilities

### Plugin Layer (SnowplowTrackerPlugin)

- Registers method channel with Flutter
- Routes method calls to appropriate handlers
- Decodes messages using generic `decodeCall` method
- Returns results to Flutter

### Controller Layer (SnowplowTrackerController)

- Manages native Snowplow tracker instances
- Converts reader messages to native SDK calls
- Handles tracker lifecycle (create, configure, track)
- Maintains tracker state across method calls

### Reader Layer (readers/)

Organized into four categories:

1. **configurations/**: Tracker and component configurations
2. **events/**: Event data structures
3. **entities/**: Context entities (media, ad, player)
4. **messages/**: Method call message structures

## Critical Import Patterns

### Standard iOS/Swift Imports

```swift
import Foundation    // Core Swift types
import Flutter      // Flutter plugin support
import SnowplowTracker  // Native iOS SDK
```

### Reader Import Organization

```swift
// ❌ Importing unnecessary frameworks
import UIKit
import CoreLocation

// ✅ Only import what's needed
import Foundation
import SnowplowTracker
```

## Essential Swift Patterns

### 1. Decodable Protocol Implementation

```swift
// ✅ Proper Decodable struct
struct ScreenViewReader: Decodable {
    let name: String
    let id: String?  // Optional fields
}
```

### 2. Extension Pattern for Conversions

```swift
// ✅ Clean conversion using extensions
extension ScreenViewReader {
    func toScreenView() -> ScreenView {
        let event = ScreenView(name: name)
        if let id = self.id { event.screenId(UUID(uuidString: id)) }
        return event
    }
}
```

### 3. Generic Decoding Helper

```swift
// ✅ Reusable generic decoder
private func decodeCall<T: Decodable>(_ call: FlutterMethodCall) -> (T, [String: Any])? {
    let decoder = JSONDecoder()
    let arguments = call.arguments as? [String: Any] ?? [:]
    // Decode and return tuple
}
```

## iOS-Specific Considerations

### 1. UUID Handling

iOS SDK requires UUID types for certain fields:

```swift
// ✅ Convert string to UUID
var idUUID: UUID? {
    if let id = self.id {
        return UUID(uuidString: id)
    }
    return nil
}
```

### 2. Platform Context Properties

iOS-specific context properties handling:

```swift
// ✅ Platform context retriever
if let pcp = self.platformContextProperties {
    let retriever = pcp.toPlatformContextRetriever()
    trackerConfig.platformContextRetriever(retriever)
}
```

### 3. Device Platform Mapping

Map Flutter platform strings to iOS SDK enums:

```swift
// ✅ Proper enum mapping
switch devicePlatform {
case "web": return DevicePlatform.web
case "iot": return DevicePlatform.internetOfThings
default: return DevicePlatform.mobile
}
```

## Common Pitfalls & Solutions

### 1. Force Unwrapping

```swift
// ❌ Force unwrapping can crash
let tracker = arguments["tracker"] as! String

// ✅ Safe optional binding
if let tracker = arguments["tracker"] as? String {
    // Use tracker
}
```

### 2. Missing Result Calls

```swift
// ❌ Forgetting to call result
private func onSetUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    SnowplowTrackerController.setUserId(message)
    // Missing result call!
}

// ✅ Always call result
private func onSetUserId(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    SnowplowTrackerController.setUserId(message)
    result(nil)
}
```

### 3. Dictionary Type Casting

```swift
// ❌ Unsafe dictionary access
let data = arguments["data"] as! [String: Any]

// ✅ Safe dictionary handling
let data = arguments["data"] as? [String: Any] ?? [:]
```

## Swift-Specific Features

### 1. Tuple Return Pattern

```swift
// Multiple return values using tuples
decodeCall(call) -> (MessageReader, [String: Any])?
```

### 2. Trailing Closure Syntax

```swift
// Clean async result handling
onGetSessionId { result in
    result(tracker?.sessionId)
}
```

### 3. Guard Statements

```swift
// ✅ Early return pattern
guard let message = decodeMessage(call) else {
    result(nil)
    return
}
// Process message
```

## Media Tracking iOS Patterns

### Ad Event Handling

```swift
// ✅ Consistent ad event pattern
private func onTrackMediaAdClickEvent(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if let (message, arguments): (TrackMediaAdEventMessageReader, [String: Any]) = decodeCall(call),
       let (eventMessage, _): (EventMessageReader, Any) = decodeCall(call) {
        SnowplowTrackerController.trackMediaAdClickEvent(message, eventMessage: eventMessage, arguments: arguments)
    }
    result(nil)
}
```

## File Structure Template

```
ios/
├── snowplow_tracker/
│   ├── Package.swift                       # Swift Package Manager specification
│   └── Sources/snowplow_tracker/
│       ├── SnowplowTrackerPlugin.swift     # Main plugin class
│       ├── SnowplowTrackerController.swift # Controller logic
│       ├── TrackerVersion.swift            # Version constants
│       └── readers/
│           ├── configurations/             # Config readers
│           │   ├── EmitterConfigurationReader.swift
│           │   ├── NetworkConfigurationReader.swift
│           │   └── TrackerConfigurationReader.swift
│           ├── events/                     # Event readers
│           │   ├── ScreenViewReader.swift
│           │   ├── StructuredReader.swift
│           │   └── SelfDescribingJsonReader.swift
│           ├── entities/                   # Entity readers
│           │   ├── MediaPlayerEntityReader.swift
│           │   └── MediaAdEntityReader.swift
│           └── messages/                   # Message readers
│               ├── CreateTrackerMessageReader.swift
│               └── EventMessageReader.swift
└── snowplow_tracker.podspec                # CocoaPods specification
```

## Quick Reference

### Reader Creation Checklist

- [ ] Define struct with `Decodable` protocol
- [ ] Map optional fields as Swift optionals
- [ ] Create conversion extension with `to*()` method
- [ ] Handle type conversions (String to UUID, etc.)
- [ ] Test with nil/missing fields

### Method Channel Handler Checklist

- [ ] Define handler method with `FlutterMethodCall` and `FlutterResult`
- [ ] Decode message using `decodeCall` generic
- [ ] Call controller method with decoded data
- [ ] Always call `result()` (even with nil)
- [ ] Handle all error cases gracefully

### iOS-Specific Checklist

- [ ] Convert string UUIDs to `UUID` type
- [ ] Map platform strings to `DevicePlatform` enum
- [ ] Handle iOS-specific configurations
- [ ] Test on both simulator and device
- [ ] Verify CocoaPods integration

## Contributing to CLAUDE.md

When adding or updating content in this document, please follow these guidelines:

### File Size Limit
- **CLAUDE.md must not exceed 40KB** (currently ~11KB)
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
