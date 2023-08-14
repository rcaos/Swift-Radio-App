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
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingLive", targets: ["NetworkingLive"])
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "NetworkingLive"
      ]
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
