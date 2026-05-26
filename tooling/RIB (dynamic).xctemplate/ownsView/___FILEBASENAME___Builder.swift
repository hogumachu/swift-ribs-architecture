//___FILEHEADER___

import RIBsArchitecture
import UIKit

public protocol ___VARIABLE_productName___Dependency: AnyObject {
  // TODO: Declare static dependencies needed to build ___VARIABLE_productName___.
}

public final class ___VARIABLE_productName___Component {
  public let dependency: ___VARIABLE_productName___Dependency
  public let dynamicComponentDependency: ___VARIABLE_productName___ComponentDependency
  
  public init(
    dependency: ___VARIABLE_productName___Dependency,
    dynamicComponentDependency: ___VARIABLE_productName___ComponentDependency
  ) {
    self.dependency = dependency
    self.dynamicComponentDependency = dynamicComponentDependency
  }
}

public final class ___VARIABLE_productName___Builder:
  ComponentizedBuilder<___VARIABLE_productName___Component, ___VARIABLE_productName___Routing, ___VARIABLE_productName___BuildDependency, ___VARIABLE_productName___ComponentDependency>,
  ___VARIABLE_productName___Buildable
{
  public init(dependency: ___VARIABLE_productName___Dependency) {
    super.init { dynamicComponentDependency in
      ___VARIABLE_productName___Component(
        dependency: dependency,
        dynamicComponentDependency: dynamicComponentDependency
      )
    }
  }
  
  public override func build(
    with component: ___VARIABLE_productName___Component,
    _ dynamicBuildDependency: ___VARIABLE_productName___BuildDependency
  ) -> ___VARIABLE_productName___Routing {
    let viewController = ___VARIABLE_productName___ViewController()
    let interactor = ___VARIABLE_productName___Interactor(presenter: viewController)
    interactor.listener = dynamicBuildDependency.listener
    
    return ___VARIABLE_productName___Router(
      interactor: interactor,
      viewController: viewController
    )
  }
}
