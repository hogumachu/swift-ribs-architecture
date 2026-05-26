//___FILEHEADER___

import RIBsArchitecture

protocol ___VARIABLE_productName___Interactable: Interactable {
  var router: ___VARIABLE_productName___Routing? { get set }
  var listener: ___VARIABLE_productName___Listener? { get set }
}

final class ___VARIABLE_productName___Router:
  Router<___VARIABLE_productName___Interactable>,
  ___VARIABLE_productName___Routing
{
  private let viewController: ___VARIABLE_productName___ViewControllable
  
  init(
    interactor: ___VARIABLE_productName___Interactable,
    viewController: ___VARIABLE_productName___ViewControllable
  ) {
    self.viewController = viewController
    super.init(interactor: interactor)
    interactor.router = self
  }
}
