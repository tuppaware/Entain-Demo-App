// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedUI",
    platforms: [
        .iOS(.v17),
       ],
    products: [
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/madebybowtie/FlagKit.git", .upToNextMajor(from: "2.4.0"))
    ],
    targets: [
        .target(
            name: "SharedUI",
            dependencies: [
                .product(name: "FlagKit", package: "FlagKit")
            ],
            resources: nil
        )
    ]
)
