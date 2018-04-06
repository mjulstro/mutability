// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Todo",
    products: [
        .library(
            name: "Todo",
            targets: ["Todo"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Todo",
            dependencies: []),
        .testTarget(
            name: "TodoTests",
            dependencies: ["Todo"]),
    ]
)
