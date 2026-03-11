import Foundation

open class SimpleMultiStageComponentizedBuilder<
  Component,
  Router
>: MultiStageComponentizedBuilder<Component, Router, Void> {
  public override init(
    componentBuilder: @escaping () -> Component
  ) {
    super.init(componentBuilder: componentBuilder)
  }
  
  public final override func finalStageBuild(
    with component: Component,
    _ dynamicDependency: Void
  ) -> Router {
    return finalStageBuild(with: component)
  }
  
  public final func finalStageBuild() -> Router {
    return finalStageBuild(withDynamicDependency: ())
  }
  
  open func finalStageBuild(with component: Component) -> Router {
    fatalError("This method should be overridden by the subclass.")
  }
}
