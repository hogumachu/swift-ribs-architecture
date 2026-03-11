//___FILEHEADER___

import RIBsArchitecture

public protocol ___VARIABLE_productName___Listener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

public protocol ___VARIABLE_productName___Routing: Routing {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

public protocol ___VARIABLE_productName___ViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

public struct ___VARIABLE_productName___BuildDependency {
  public let listener: ___VARIABLE_productName___Listener
  public let viewController: ___VARIABLE_productName___ViewControllable

  public init(
    listener: ___VARIABLE_productName___Listener,
    viewController: ___VARIABLE_productName___ViewControllable
  ) {
    self.listener = listener
    self.viewController = viewController
  }
}

public protocol ___VARIABLE_productName___Buildable: Buildable {
  func build(with dynamicBuildDependency: ___VARIABLE_productName___BuildDependency) -> ___VARIABLE_productName___Routing
}
