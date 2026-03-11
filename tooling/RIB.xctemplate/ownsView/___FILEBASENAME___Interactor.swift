//___FILEHEADER___

import RIBsArchitecture

protocol ___VARIABLE_productName___Routing: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ___VARIABLE_productName___Presentable: Presentable {
  var listener: ___VARIABLE_productName___PresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ___VARIABLE_productName___PresentableListener: AnyObject {
  // TODO: Declare methods and properties that the view controller invokes to perform business logic.
}

protocol ___VARIABLE_productName___Listener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol ___VARIABLE_productName___Interactable: Interactable {
  var router: ___VARIABLE_productName___Routing? { get set }
  var listener: ___VARIABLE_productName___Listener? { get set }
}

final class ___VARIABLE_productName___Interactor:
  PresentableInteractor<___VARIABLE_productName___Presentable>,
  ___VARIABLE_productName___Interactable,
  ___VARIABLE_productName___PresentableListener
{
  weak var router: ___VARIABLE_productName___Routing?
  weak var listener: ___VARIABLE_productName___Listener?

  override init(presenter: ___VARIABLE_productName___Presentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }

  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
