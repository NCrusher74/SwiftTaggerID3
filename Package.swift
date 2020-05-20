// swift-tools-version:5.2

/*

 Package.swift
 SwiftTaggerID3

 Copyright ©2020 Nolaine Crusher. All rights reserved.

 */

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
        .exact(Version(0, 32, 3)))
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

        // This internal‐only target is not actually needed for anything; the “Workspace.swift” file on its own is sufficient. However, having it also hooked up this way enables Xcode to provide syntax colouring and autocomplete while you are making changes to the configuration.
        .target(
          name: "WorkspaceConfigurationFile",
          dependencies: [.product(name: "WorkspaceConfiguration", package: "Workspace")],
          path: "",
          sources: ["Workspace.swift"]
        )
    ]
)
