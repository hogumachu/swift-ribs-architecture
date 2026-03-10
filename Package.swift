// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "swift-ribs-architecture",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "RIBsArchitecture",
      targets: ["RIBsArchitecture"]
    ),
  ],
  targets: [
    .target(
      name: "RIBsArchitecture",
      dependencies: [
        "RIBsDependency"
      ]
    ),
    .target(
      name: "RIBsDependency"
    )
  ]
)
