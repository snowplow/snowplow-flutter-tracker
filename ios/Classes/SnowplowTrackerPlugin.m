#import "SnowplowTrackerPlugin.h"
#if __has_include(<snowplow_tracker/snowplow_tracker-Swift.h>)
#import <snowplow_tracker/snowplow_tracker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "snowplow_tracker-Swift.h"
#endif

@implementation SnowplowTrackerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSnowplowTrackerPlugin registerWithRegistrar:registrar];
}
@end
