//___FILEHEADER___

import RIBsArchitecture
import UIKit

public final class ___VARIABLE_productName___Builder: ___VARIABLE_productName___Buildable {
  public init() {}

  public func build(with dynamicBuildDependency: ___VARIABLE_productName___BuildDependency) -> ___VARIABLE_productName___Routing {
    let viewController = ___VARIABLE_productName___ViewController()
    let interactor = ___VARIABLE_productName___Interactor(presenter: viewController)
    interactor.listener = dynamicBuildDependency.listener
    return ___VARIABLE_productName___Router(
      interactor: interactor,
      viewController: viewController
    )
  }
}
