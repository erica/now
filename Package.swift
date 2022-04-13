// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "now",
    platforms: [
      .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "now",
            targets: ["now"]),
    ],
    dependencies: [
      .package(
        url:"https://github.com/apple/swift-argument-parser",
		.upToNextMajor(from: "1.1.2")),
    ],
    targets: [
        .executableTarget(
            name: "now",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")],
            path: "now/"
            ),
    ],
    swiftLanguageVersions: [
      .v5
    ]
)
