//___FILEHEADER___

import RIBsArchitecture
import UIKit

protocol ___VARIABLE_productName___Buildable: Buildable {
  func build(withListener listener: ___VARIABLE_productName___Listener) -> ___VARIABLE_productName___Routing
}

final class ___VARIABLE_productName___Builder: ___VARIABLE_productName___Buildable {
  func build(withListener listener: ___VARIABLE_productName___Listener) -> ___VARIABLE_productName___Routing {
    let viewController = ___VARIABLE_productName___ViewController()
    let interactor = ___VARIABLE_productName___Interactor(presenter: viewController)
    interactor.listener = listener
    return ___VARIABLE_productName___Router(
      interactor: interactor,
      viewController: viewController
    )
  }
}
