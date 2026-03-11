import RIBsArchitecture

final class ComponentizedBuilderMock:
  ComponentizedBuilder<ComponentizedBuilderMock.Component, ComponentizedBuilderMock.Router, Void, Void> {
  final class Component {}
  final class Router {}
  
  var buildCallCount = 0
  var buildComponent: Component?
  var buildResult: Router?
  override func build(
    with component: Component,
    _ dynamicBuildDependency: Void
  ) -> Router {
    buildCallCount += 1
    buildComponent = component
    return { _, _ in
      return buildResult ?? .init()
    }(component, dynamicBuildDependency)
  }
}
