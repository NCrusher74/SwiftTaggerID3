// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTaggerID3",
    products: [.library(name: "SwiftTaggerID3", targets: ["SwiftTaggerID3"]),],
    dependencies: [
        .package(
            name: "Workspace",
            url: "https://github.com/SDGGiesbrecht/Workspace",
            .upToNextMinor(from: Version(0, 32, 3))
        ),
    ],
    targets: [
        .target(
            name: "SwiftTaggerID3",
            dependencies: [
                .product(name: "WorkspaceConfiguration", package: "Workspace"),
        ]),
        .testTarget(
            name: "SwiftTaggerID3Tests",
            dependencies: ["SwiftTaggerID3"]),
    ]
)
