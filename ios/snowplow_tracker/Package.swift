// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "snowplow_tracker",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "snowplow-tracker", targets: ["snowplow_tracker"])
    ],
    dependencies: [
        .package(url: "https://github.com/snowplow/snowplow-ios-tracker.git", from: "6.2.2")
    ],
    targets: [
        .target(
            name: "snowplow_tracker",
            dependencies: [
                .product(name: "SnowplowTracker", package: "snowplow-ios-tracker")
            ]
        )
    ]
)
