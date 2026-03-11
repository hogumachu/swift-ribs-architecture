//___FILEHEADER___

import RIBsArchitecture

public protocol ___VARIABLE_productName___Routing: Routing {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

public protocol ___VARIABLE_productName___Listener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol ___VARIABLE_productName___Interactable: Interactable {
  var listener: ___VARIABLE_productName___Listener? { get set }
}

final class ___VARIABLE_productName___Interactor: Interactor, ___VARIABLE_productName___Interactable {
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
