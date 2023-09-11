// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RadioApp",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "AudioPlayerClient", targets: ["AudioPlayerClient"]),
    .library(name: "Env", targets: ["Env"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingLive", targets: ["NetworkingLive"]),
    .library(name: "PlayerFeature", targets: ["PlayerFeature"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-async-algorithms.git", .upToNextMajor(from: .init(stringLiteral: "0.1.0")) )
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "Env",
        "NetworkingLive",
        "PlayerFeature"
      ]
    ),
    .target(
      name: "AudioPlayerClient",
      dependencies: []
    ),
    .target(name: "Env"),
    .target(
      name: "Networking"
    ),
    .target(
      name: "NetworkingLive",
      dependencies: [
        "Networking"
      ]
    ),
    .target(
      name: "PlayerFeature",
      dependencies: [
        "AudioPlayerClient",
        "Env",
        "Networking",
        .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
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
