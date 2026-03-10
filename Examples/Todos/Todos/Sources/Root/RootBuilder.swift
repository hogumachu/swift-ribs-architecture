import UIKit
import ViperArchitecture

protocol RootBuildable: Buildable {
  func build() -> LaunchRouting
}

final class RootBuilder: RootBuildable {
  func build() -> LaunchRouting {
    let viewController = RootViewController()
    let interactor = RootInteractor(presenter: viewController)
    let router = RootRouter(
      interactor: interactor,
      viewController: viewController
    )
    return router
  }
}
