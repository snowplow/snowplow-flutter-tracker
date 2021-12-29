#import "SnowplowFlutterTrackerPlugin.h"
#if __has_include(<snowplow_flutter_tracker/snowplow_flutter_tracker-Swift.h>)
#import <snowplow_flutter_tracker/snowplow_flutter_tracker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "snowplow_flutter_tracker-Swift.h"
#endif

@implementation SnowplowFlutterTrackerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSnowplowFlutterTrackerPlugin registerWithRegistrar:registrar];
}
@end
