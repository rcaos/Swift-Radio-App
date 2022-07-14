// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RadioApp",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v12)
  ],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    // .library(name: "Networking", targets: ["Networking"]),
    // .library(name: "NetworkingInterface", targets: ["NetworkingInterface"]),
    // .library(name: "Persistence", targets: ["Persistence"]),
    // .library(name: "PersistenceLive", targets: ["PersistenceLive"])
  ],
  dependencies: [
    // .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "14.0.0"),
    // .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.2.1"),
    // .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.3"),
    // .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0")
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        // "Networking"
      ])
  ]
)
