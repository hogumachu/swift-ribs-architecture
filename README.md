# RIBsArchitecture

## Why This Project

- Keep the core architecture and lifecycle model of [uber/ribs-ios](https://github.com/uber/ribs-ios).
- Remove RxSwift as a required dependency for lighter adoption.
- Use Combine internally while exposing Swift Concurrency-friendly APIs (`Task`, `async/await`) to app code.

## Credits & References

- Upstream RIBs implementation: [uber/ribs-ios](https://github.com/uber/ribs-ios)
- Additional reference: [DevYeom/ModernRIBs](https://github.com/DevYeom/ModernRIBs)

## Installation (SPM)

Add the package dependency to your `Package.swift`:

```swift
dependencies: [
  .package(
    url: "https://github.com/hogumachu/swift-ribs-architecture.git",
    branch: "main"
  )
]
```

Link the product in your target:

```swift
targets: [
  .target(
    name: "YourFeature",
    dependencies: [
      .product(name: "RIBsArchitecture", package: "swift-ribs-architecture")
    ]
  )
]
```
