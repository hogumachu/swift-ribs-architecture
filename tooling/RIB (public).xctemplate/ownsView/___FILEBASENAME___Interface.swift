//___FILEHEADER___

import RIBsArchitecture

public protocol ___VARIABLE_productName___Listener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

public protocol ___VARIABLE_productName___Routing: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

public struct ___VARIABLE_productName___BuildDependency {
  public let listener: ___VARIABLE_productName___Listener

  public init(listener: ___VARIABLE_productName___Listener) {
    self.listener = listener
  }
}

public protocol ___VARIABLE_productName___Buildable: Buildable {
  func build(with dynamicBuildDependency: ___VARIABLE_productName___BuildDependency) -> ___VARIABLE_productName___Routing
}
