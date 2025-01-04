// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NavidromeAPI",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [.library(name: "NavidromeAPI", targets: ["NavidromeAPI"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.0.2"),
        .package(url: "https://github.com/OtoFlow/SubsonicSDK-Swift.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "NavidromeAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "SubsonicAPI", package: "SubsonicAPI"),
            ],
            exclude: [
                "openapi.yaml",
                "openapi-generator-config.yaml",
            ]
        ),
    ]
)
