// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "now",
    platforms: [
      .macOS(.v10_12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(
            name: "now",
            targets: ["now"]),
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.6"),
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
