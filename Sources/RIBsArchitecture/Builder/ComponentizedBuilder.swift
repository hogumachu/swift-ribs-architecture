import Foundation

open class ComponentizedBuilder<
  Component,
  Router,
  DynamicBuildDependency,
  DynamicComponentDependency
>: Buildable {
  
  private let componentBuilder: (DynamicComponentDependency) -> Component
  private weak var lastComponent: AnyObject?
  
  public init(
    componentBuilder: @escaping (DynamicComponentDependency) -> Component
  ) {
    self.componentBuilder = componentBuilder
  }
  
  public final func build(
    withDynamicBuildDependency dynamicBuildDependency: DynamicBuildDependency,
    dynamicComponentDependency: DynamicComponentDependency
  ) -> Router {
    return build(
      withDynamicBuildDependency: dynamicBuildDependency,
      dynamicComponentDependency: dynamicComponentDependency
    ).1
  }
  
  public final func build(
    withDynamicBuildDependency dynamicBuildDependency: DynamicBuildDependency,
    dynamicComponentDependency: DynamicComponentDependency
  ) -> (Component, Router) {
    let component = componentBuilder(dynamicComponentDependency)
    let newComponent = component as AnyObject
    if lastComponent === newComponent {
      assertionFailure("\(self) componentBuilder should produce new instances of component when build is invoked.")
    }
    lastComponent = newComponent
    return (component, build(with: component, dynamicBuildDependency))
  }
  
  open func build(
    with component: Component,
    _ dynamicBuildDependency: DynamicBuildDependency
  ) -> Router {
    fatalError("This method should be overridden by the subclass.")
  }
}
