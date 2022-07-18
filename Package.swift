// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RadioApp",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "Domain", targets: ["Domain"]),
    .library(name: "Networking", targets: ["Networking"]),
    .library(name: "NetworkingInterface", targets: ["NetworkingInterface"]),
    .library(name: "Persistence", targets: ["Persistence"]),
    .library(name: "RadioPlayer", targets: ["RadioPlayer"]),
    // .library(name: "PersistenceLive", targets: ["PersistenceLive"])
  ],
  dependencies: [
    .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.3.0"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0")
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        .product(name: "RxSwift", package: "RxSwift"),
        .product(name: "Kingfisher", package: "Kingfisher"),
        "Networking",
        "RadioPlayer"
      ]),
    .target(name: "Domain", dependencies: [
      .product(name: "RxSwift", package: "RxSwift")
    ]),
    .target(
      name: "Networking",
      dependencies: [
        "NetworkingInterface"
      ]),
    .target(name: "NetworkingInterface"),
    .target(name: "Persistence"),
    .target(
      name: "RadioPlayer",
      dependencies: [
        .product(name: "RxSwift", package: "RxSwift"),
        "Domain"
      ])
  ]
)
