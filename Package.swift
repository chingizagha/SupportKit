// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SupportKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SupportKit",
            targets: ["SupportKit"]),
    ],
    targets: [
        .target(
            name: "SupportKit")
    ]
)
