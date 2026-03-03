// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "swift-viper-architecture",
  platforms: [
    .iOS(.v15)
  ],
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
