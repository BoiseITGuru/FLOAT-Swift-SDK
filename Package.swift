// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FLOATSwiftSDK",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FLOATSwiftSDK",
            targets: ["FLOATSwiftSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/Outblock/fcl-swift", .upToNextMajor(from: "0.0.3")),
        .package(path: "/Users/boiseitguru/Development/Flow/fcl-swift"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FLOATSwiftSDK",
            dependencies: [.product(name: "FCL", package: "fcl-swift")]),
        .testTarget(
            name: "FLOATSwiftSDKTests",
            dependencies: ["FLOATSwiftSDK"]),
    ]
)
