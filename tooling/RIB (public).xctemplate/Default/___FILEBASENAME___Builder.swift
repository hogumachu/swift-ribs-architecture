//___FILEHEADER___

import RIBsArchitecture

public final class ___VARIABLE_productName___Builder: ___VARIABLE_productName___Buildable {
  public init() {}

  public func build(with dynamicBuildDependency: ___VARIABLE_productName___BuildDependency) -> ___VARIABLE_productName___Routing {
    let interactor = ___VARIABLE_productName___Interactor()
    interactor.listener = dynamicBuildDependency.listener
    return ___VARIABLE_productName___Router(
      interactor: interactor,
      viewController: dynamicBuildDependency.viewController
    )
  }
}
