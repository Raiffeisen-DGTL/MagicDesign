// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MagicDesign",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MagicDesign",
            targets: ["MagicDesign"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Raiffeisen-DGTL/raifmagiccore.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MagicDesign",
            dependencies: [
                .product(name: "RaifMagicCore", package: "RaifMagicCore"),
            ]
        ),
    ]
)
