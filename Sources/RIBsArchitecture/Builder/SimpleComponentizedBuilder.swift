import Foundation

open class SimpleComponentizedBuilder<Component, Router>: ComponentizedBuilder<Component, Router, Void, Void> {
  
  public init(
    componentBuilder: @escaping () -> Component
  ) {
    super.init(componentBuilder: componentBuilder)
  }
  
  public final override func build(
    with component: Component,
    _ dynamicDependency: Void
  ) -> Router {
    return build(with: component)
  }
  
  public final func build() -> Router {
    return build(withDynamicBuildDependency: (), dynamicComponentDependency: ())
  }
  
  open func build(with component: Component) -> Router {
    fatalError("This method should be overriden by the subclass.")
  }
}
