//___FILEHEADER___

import RIBsArchitecture

protocol ___VARIABLE_productName___ViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ___VARIABLE_productName___Router:
  ViewableRouter<___VARIABLE_productName___Interactable, ___VARIABLE_productName___ViewControllable>,
  ___VARIABLE_productName___Routing
{
  init(
    interactor: ___VARIABLE_productName___Interactable,
    viewController: ___VARIABLE_productName___ViewControllable
  ) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
