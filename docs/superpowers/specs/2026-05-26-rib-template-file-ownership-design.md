# RIB Template File Ownership Design

## Goal

Update the Xcode RIB templates so generated protocols and concrete types are placed in the same files as the Splash reference structure, add a dynamic component template, and add ergonomic `ComponentizedBuilder` build overloads.

## Scope

- Keep existing template folder/module behavior.
- Reposition declarations inside generated Swift files.
- Add `RIB (dynamic).xctemplate` as a new template rather than changing existing `RIB.xctemplate` semantics.
- Add convenience APIs without removing the current `build(withDynamicBuildDependency:dynamicComponentDependency:)` methods.

## File Ownership

For view-owning RIBs:

- `*Interface.swift` owns public external contracts: `Listener`, `Routing`, `BuildDependency`, and `Buildable`.
- `*Router.swift` owns router-adjacent implementation protocols: `Interactable`, `ViewControllable`, and `Router`.
- `*Interactor.swift` owns `Presentable` and the concrete `Interactor`.
- `*ViewController.swift` owns `PresentableListener` and the concrete `ViewController`.

For non-view-owning public RIBs:

- `*Interface.swift` keeps `Listener`, `Routing`, `ViewControllable`, `BuildDependency`, and `Buildable`, because the view controller is externally supplied.
- `*Interactor.swift` owns only `Interactable` and the concrete `Interactor`.

## Dynamic Template

`RIB (dynamic).xctemplate` generates a componentized public RIB:

- `*Dependency` protocol for static component dependencies.
- `*ComponentDependency` struct for dynamic component dependencies.
- `*Component` final class that stores static and dynamic component dependencies.
- `*Builder` subclass of `ComponentizedBuilder<*Component, *Routing, *BuildDependency, *ComponentDependency>`.
- `Buildable` uses the short `build(with:_:)` API made available by `ComponentizedBuilder` extensions.

## Builder API

Add overloads to `ComponentizedBuilder`:

- `build(with:_:)` for both dynamic build and component dependencies.
- `build()` when both dynamic dependencies are `Void`.
- `build(with:)` when the dynamic component dependency is `Void`.
- `build(with:)` when the dynamic build dependency is `Void`.

These overloads delegate to the existing long-form API and preserve the component freshness assertion.

## Testing

- Add tests for all convenience overloads.
- Verify generated template syntax by checking placeholders and running the package test suite.
