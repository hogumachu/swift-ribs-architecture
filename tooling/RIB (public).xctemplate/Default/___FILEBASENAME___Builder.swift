//___FILEHEADER___

import RIBsArchitecture

public protocol ___VARIABLE_productName___Buildable: Buildable {
  func build(
    withListener listener: ___VARIABLE_productName___Listener,
    viewController: ___VARIABLE_productName___ViewControllable
  ) -> ___VARIABLE_productName___Routing
}

public final class ___VARIABLE_productName___Builder: ___VARIABLE_productName___Buildable {
  public init() {}

  public func build(
    withListener listener: ___VARIABLE_productName___Listener,
    viewController: ___VARIABLE_productName___ViewControllable
  ) -> ___VARIABLE_productName___Routing {
    let interactor = ___VARIABLE_productName___Interactor()
    interactor.listener = listener
    return ___VARIABLE_productName___Router(
      interactor: interactor,
      viewController: viewController
    )
  }
}
