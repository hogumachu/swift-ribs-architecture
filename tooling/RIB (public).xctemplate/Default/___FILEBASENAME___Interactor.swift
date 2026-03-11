//___FILEHEADER___

import RIBsArchitecture

protocol ___VARIABLE_productName___Interactable: Interactable {
  var router: ___VARIABLE_productName___Routing? { get set }
  var listener: ___VARIABLE_productName___Listener? { get set }
}

final class ___VARIABLE_productName___Interactor: Interactor, ___VARIABLE_productName___Interactable {
  weak var router: ___VARIABLE_productName___Routing?
  weak var listener: ___VARIABLE_productName___Listener?

  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }

  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
