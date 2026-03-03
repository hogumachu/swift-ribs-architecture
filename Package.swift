// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "swift-viper-architecture",
  products: [
    .library(
      name: "ViperArchitecture",
      targets: ["ViperArchitecture"]
    ),
  ],
  targets: [
    .target(
      name: "ViperArchitecture"
    ),
  ]
)
