// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTaggerID3",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftTaggerID3",
            targets: ["SwiftTaggerID3"]),
    ],
    dependencies: [
        .package(
            name: "Workspace",
            url: "https://github.com/SDGGiesbrecht/Workspace",
            .upToNextMinor(from: Version(0, 32, 3))
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftTaggerID3",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "SwiftTaggerID3Tests",
            dependencies: ["SwiftTaggerID3"]),
    ]
)
