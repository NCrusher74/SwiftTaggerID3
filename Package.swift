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
            url: "https://github.com/NCrusher74/SwiftLanguageAndLocaleCodes",
            from: "1.0.0"),
        .package(
            url: "https://github.com/NCrusher74/SwiftConvenienceExtensions",
            from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftTaggerID3",
            dependencies: [
                .product(name: "SwiftLanguageAndLocaleCodes", package: "SwiftLanguageAndLocaleCodes"),
                .product(name: "SwiftConvenienceExtensions", package: "SwiftConvenienceExtensions"),
            ],
            path: "Sources"),
        .testTarget(
            name: "SwiftTaggerID3Tests",
            dependencies: ["SwiftTaggerID3"]),
    ]
)
