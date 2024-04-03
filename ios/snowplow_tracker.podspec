#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint snowplow_tracker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'snowplow_tracker'
  s.version          = '0.6.0'
  s.summary          = 'A package for tracking Snowplow events in Flutter apps.'
  s.description      = <<-DESC
A package for tracking Snowplow events in Flutter apps.
                       DESC
  s.homepage         = 'https://github.com/snowplow/snowplow-flutter-tracker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Snowplow Analytics Ltd' => 'support@snowplowanalytics.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'SnowplowTracker', '~> 6.0.2'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
