// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DemoAuthenticator",
    platforms: [
        .iOS("10.3")
    ],
    products: [
        .library(
            name: "DemoAuthenticator",
            targets: ["DemoAuthenticator"]
        )
    ],
    targets: [
        .target(
            name: "DemoAuthenticator",
            dependencies: []
        )
    ]
)
