// swift-tools-version: 6.1

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
  dependencies: [
    // Test Dependencies
    .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting.git", from: "2.2.2")
  ],
  targets: [
    .target(
      name: "RIBsArchitecture",
      dependencies: [
        "RIBsDependency"
      ]
    ),
    .target(
      name: "RIBsDependency",
    ),
    .testTarget(
      name: "RIBsArchitectureTests",
      dependencies: [
        "RIBsArchitecture",
        "CwlPreconditionTesting",
      ]
    )
  ]
)
