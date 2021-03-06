// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "now",
    platforms: [
      .macOS(.v10_12)
    ],
    products: [
        .executable(
            name: "now",
            targets: ["now"]),
    ],
    dependencies: [
      .package(
        url:"https://github.com/apple/swift-argument-parser",
        .exact("0.0.6")),
    ],
    targets: [
        .target(
            name: "now",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")],
            path: "now/"
            ),
    ],
    swiftLanguageVersions: [
      .v5
    ]
)
