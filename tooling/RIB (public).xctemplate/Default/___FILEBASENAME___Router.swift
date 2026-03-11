//___FILEHEADER___

import RIBsArchitecture

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
