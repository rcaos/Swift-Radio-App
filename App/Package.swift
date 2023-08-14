// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RadioApp",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "AudioPlayerClient", targets: ["AudioPlayerClient"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingLive", targets: ["NetworkingLive"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-async-algorithms.git", .upToNextMajor(from: .init(stringLiteral: "0.1.0")) )
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "NetworkingLive",
        "AudioPlayerClient",
        .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
      ]
    ),
    .target(
      name: "AudioPlayerClient",
      dependencies: []
    ),
    .target(
      name: "Networking"
    ),
    .target(
      name: "NetworkingLive",
      dependencies: [
        "Networking"
      ]
    ),
    .testTarget(
      name: "AppFeatureTests",
      dependencies: [
        "AppFeature"
      ]
    ),
    .testTarget(
      name: "NetworkingTests",
      dependencies: [
        "NetworkingLive"
      ]
    )
  ]
)
