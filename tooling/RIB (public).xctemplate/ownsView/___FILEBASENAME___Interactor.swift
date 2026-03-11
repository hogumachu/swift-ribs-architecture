//___FILEHEADER___

import RIBsArchitecture

protocol ___VARIABLE_productName___Presentable: Presentable {
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ___VARIABLE_productName___Interactable: Interactable {
  var listener: ___VARIABLE_productName___Listener? { get set }
}

final class ___VARIABLE_productName___Interactor:
  PresentableInteractor<___VARIABLE_productName___Presentable>,
  ___VARIABLE_productName___Interactable
{
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
