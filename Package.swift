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
     .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.3.0"),
     .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "4.0.0"),
     .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0")
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        .product(name: "RxSwift", package: "RxSwift"),
        .product(name: "RxDataSources", package: "RxDataSources"),
        .product(name: "Kingfisher", package: "Kingfisher")
        // "Networking"
      ])
  ]
)