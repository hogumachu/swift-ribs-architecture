import Foundation

open class MultiStageComponentizedBuilder<
  Component,
  Router,
  DynamicBuildDependency
>: Buildable {
  public var componentForCurrentBuildPass: Component {
    if let currentPassComponent {
      return currentPassComponent
    }
    
    let currentPassComponent = componentBuilder()
    let newComponent = currentPassComponent as AnyObject
    if lastComponent === newComponent {
      assertionFailure("\(self) componentBuilder should produce new instances of component when build is invoked.")
    }
    lastComponent = newComponent
    
    self.currentPassComponent = currentPassComponent
    return currentPassComponent
  }
  
  private let componentBuilder: () -> Component
  private var currentPassComponent: Component?
  private weak var lastComponent: AnyObject?
  
  public init(
    componentBuilder: @escaping () -> Component
  ) {
    self.componentBuilder = componentBuilder
  }
  
  public final func finalStageBuild(
    withDynamicDependency dynamicDependency: DynamicBuildDependency
  ) -> Router {
    let router = finalStageBuild(with: componentForCurrentBuildPass, dynamicDependency)
    defer {
      currentPassComponent = nil
    }
    return router
  }
  
  open func finalStageBuild(with component: Component, _ dynamicDependency: DynamicBuildDependency) -> Router {
    fatalError("This method should be overridden by the subclass.")
  }
}
