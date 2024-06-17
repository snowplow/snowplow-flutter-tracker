# 0.7.1

* Automatically generate ID for ScreenViews (#55)

# 0.7.0

* Add media tracking APIs to the tracker (#49)
* Fix tracker initialization with partial platform context property overrides on Android (#53)
* Update uuid package constraint to 4.0.0 (#48) thanks to @petermnt
* Add support for Android Gradle Plugin 8 (#46) thanks to @petermnt
* Remove documentation in the project in favour of docs.snowplow.io to reduce duplicity (#51)
* Update flutter_lints, http, js, and example dependency versions (#52)

# 0.6.0

* Upgrade mobile trackers to version 6.0
* Add support for mobile screen engagement tracking including list item view and scroll changed events (#43)
* Add configuration to override platform context properties in the mobile context including the IDFA identifiers (#44)
* Update SDK constraint to <4.0.0 (#42)
* Fix publish action (#38)
* Remove deprecated setMockMethodCallHandler from tests (#41)
* Move the repository to the snowplow Github organization (#29)
* Update copyright headers

# 0.5.0

*  Add lifecycle autotracking config option (#39)

# 0.4.0

* Add configuration for setting custom HTTP headers for requests to the collector (#34)
* Upgrade underlying iOS and Android trackers to version 5 (#36)
* Remove deprecated kotlin-android-extensions plugin in example app (#35)
* Upgrade JavaScript tracker in the example app to version 3.13

# 0.3.0

* Enable screen and application context on mobile (#27)  
* Add anonymous tracking features (#16)

# 0.2.0

* Configure custom POST path (#15)  
* Upgrade underlying mobile native trackers to version 4 (#17)  
* Fix schema link in documentation for ScreenView (#12)  
* Remove loading custom JavaScript for session context and reading cookies (#13)  
* Upgrade min Flutter, Dart and Android SDK versions and upgrade dependencies (#19) - thanks @koga for the Android work!  

# 0.1.0

* Add route observer for auto tracking screen or page view events on navigation (#9)

# 0.1.0-alpha.2

* Add page view events and activity tracking on Web (#6)

# 0.1.0-alpha.1

* Add action to publish release to pub.dev and GitHub (#3)

# 0.1.0-dev.1

* Initial pre-release.
