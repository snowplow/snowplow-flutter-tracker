# CLAUDE.md - Configurations Module Documentation

## Module Overview

The configurations module provides immutable configuration objects for initializing and customizing Snowplow trackers. These configurations control tracker behavior, network settings, data collection policies, and platform-specific features.

**Configuration Types:**
- `Configuration` - Root configuration wrapper
- `NetworkConfiguration` - Collector endpoint settings
- `TrackerConfiguration` - Core tracker features
- `SubjectConfiguration` - User/subject information
- `GdprConfiguration` - GDPR compliance settings
- `EmitterConfiguration` - Event batching and sending
- `MediaTrackingConfiguration` - Media player tracking
- `WebActivityTracking` - Web-specific activity tracking

## Configuration Design Pattern

### Immutable Configuration Template
```dart
@immutable
class XConfiguration {
  final String? optionalField;
  final bool? featureFlag;
  
  const XConfiguration({
    this.optionalField,
    this.featureFlag,
  });
  
  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'optionalField': optionalField,
      'featureFlag': featureFlag,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}
```

## Core Configuration Patterns

### 1. Root Configuration Wrapper
```dart
// ✅ Correct: Configuration aggregates all settings
final config = Configuration(
  namespace: 'tracker1',            // Required
  networkConfig: NetworkConfiguration(...), // Required
  trackerConfig: TrackerConfiguration(...), // Optional
);

// ❌ Wrong: Missing required configs
final config = Configuration(
  namespace: 'tracker1', // Missing networkConfig
);
```

### 2. Network Configuration
```dart
// ✅ Correct: Minimal network config
NetworkConfiguration(
  endpoint: 'https://collector.example.com',
  method: Method.post,  // Optional, defaults to POST
);

// ❌ Wrong: Invalid endpoint
NetworkConfiguration(
  endpoint: 'not-a-url', // Must be valid URL
);
```

### 3. Tracker Configuration Options
```dart
// ✅ Correct: Platform-aware configuration
TrackerConfiguration(
  appId: 'my-app',
  platformContext: !kIsWeb,     // Not on Web
  webPageContext: kIsWeb,       // Only on Web
  devicePlatform: DevicePlatform.mob,
);

// ❌ Wrong: Conflicting platform settings
TrackerConfiguration(
  webPageContext: true,  // Web feature
  platformContext: true, // Mobile feature
);
```

## Platform-Specific Patterns

### Web-Only Configuration
```dart
// ✅ Correct: Web activity tracking
TrackerConfiguration(
  webActivityTracking: WebActivityTracking(
    minimumVisitLength: 15,
    heartbeatDelay: 10,
    trackPageViewsInObserver: true,
  ),
  jsMediaPluginURL: 'https://cdn.../media.js',
);
```

### Mobile-Only Configuration
```dart
// ✅ Correct: Mobile platform properties
TrackerConfiguration(
  platformContextProperties: PlatformContextProperties(
    appleIdfa: 'uuid-string',
    androidIdfa: 'uuid-string',
  ),
  lifecycleAutotracking: true,
  screenEngagementAutotracking: true,
);
```

### Cross-Platform Configuration
```dart
// ✅ Correct: Adaptive configuration
TrackerConfiguration(
  sessionContext: true,        // All platforms
  geoLocationContext: false,   // All platforms
  applicationContext: !kIsWeb, // Mobile only
);
```

## Configuration Hierarchies

### Nullable Fields Pattern
All configuration fields should be nullable to allow defaults:
```dart
// ✅ Correct: Nullable for defaults
class EmitterConfiguration {
  final int? bufferSize;      // null = use default
  final int? emitRange;       // null = use default
}

// ❌ Wrong: Required fields prevent defaults
class EmitterConfiguration {
  final int bufferSize;       // Forces value
}
```

### Enum Configuration
```dart
// ✅ Correct: Enum for constrained values
enum DevicePlatform {
  mob, web, pc, srv, app, tv, cnsl, iot
}
enum Method { get, post }
enum LogLevel { off, error, debug, verbose }

// ❌ Wrong: String for constrained values
String devicePlatform = 'mobile'; // Error-prone
```

## GDPR Configuration Pattern

### Consent Basis Documentation
```dart
// ✅ Correct: Complete GDPR configuration
GdprConfiguration(
  basisForProcessing: 'consent',
  documentId: 'privacy-policy-v1',
  documentVersion: '1.0.0',
  documentDescription: 'User consent for analytics',
);

// ❌ Wrong: Incomplete GDPR data
GdprConfiguration(
  basisForProcessing: 'consent', // Missing document info
);
```

## Media Tracking Configuration

### Required Media ID
```dart
// ✅ Correct: Unique media tracking ID
MediaTrackingConfiguration(
  id: 'video-player-home-123',
  captureEvents: [MediaEvent.play, MediaEvent.pause],
);

// ❌ Wrong: Missing or non-unique ID
MediaTrackingConfiguration(); // ID is required
```

## Subject Configuration

### User Identification
```dart
// ✅ Correct: User properties
SubjectConfiguration(
  userId: 'user123',
  networkUserId: 'network456',
  domainUserId: 'domain789',
  userAgent: 'CustomApp/1.0',
  timezone: 'America/New_York',
);

// ❌ Wrong: PII in wrong fields
SubjectConfiguration(
  userId: 'john@example.com', // Use hashed ID
);
```

## Configuration Validation

### Platform Compatibility Check
```dart
// ✅ Correct: Check platform support
if (!kIsWeb && trackerConfig.platformContext != null) {
  // Apply mobile-only configuration
}

// ❌ Wrong: Apply without checking
trackerConfig.platformContext = true; // Fails on Web
```

### Configuration Merging
```dart
// ✅ Correct: Override with null check
final config = baseConfig.copyWith(
  appId: newAppId ?? baseConfig.appId,
);

// ❌ Wrong: Direct override
baseConfig.appId = newAppId; // Immutable!
```

## Common Configuration Mistakes

### 1. Mutating Configuration
```dart
// ❌ Wrong: Trying to mutate
config.trackerConfig.appId = 'new-id';

// ✅ Correct: Create new instance
final newConfig = Configuration(
  namespace: config.namespace,
  networkConfig: config.networkConfig,
  trackerConfig: TrackerConfiguration(appId: 'new-id'),
);
```

### 2. Missing Platform Checks
```dart
// ❌ Wrong: Web-incompatible config
TrackerConfiguration(
  platformContext: true, // Crashes on Web
);

// ✅ Correct: Platform-aware
TrackerConfiguration(
  platformContext: kIsWeb ? null : true,
);
```

### 3. Invalid Enum Values
```dart
// ❌ Wrong: String instead of enum
final method = 'POST'; // Should use enum

// ✅ Correct: Use enum
final method = Method.post;
```

## Configuration Testing

```dart
test('configuration serialization', () {
  final config = TrackerConfiguration(
    appId: 'test-app',
    sessionContext: true,
  );
  
  final map = config.toMap();
  expect(map['appId'], 'test-app');
  expect(map['sessionContext'], true);
  expect(map.containsKey('platformContext'), false);
});
```

## Quick Reference

### Configuration Checklist
- [ ] All fields are `final` and nullable
- [ ] Has `@immutable` annotation
- [ ] Has const constructor
- [ ] `toMap()` method removes null values
- [ ] Platform-specific fields documented
- [ ] Enums used for constrained values

### Platform Feature Matrix
| Feature | iOS | Android | Web |
|---------|-----|---------|-----|
| platformContext | ✅ | ✅ | ❌ |
| webPageContext | ❌ | ❌ | ✅ |
| lifecycleAutotracking | ✅ | ✅ | ❌ |
| installAutotracking | ✅ | ✅ | ❌ |
| webActivityTracking | ❌ | ❌ | ✅ |
| screenContext | ✅ | ✅ | ❌ |
| applicationContext | ✅ | ✅ | ❌ |

### Default Values
- `base64Encoding`: true
- `sessionContext`: true
- `method`: Method.post
- `devicePlatform`: "mob" (mobile), "web" (web)
- `platformContext`: true (mobile only)
- `installAutotracking`: false (mobile only)

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