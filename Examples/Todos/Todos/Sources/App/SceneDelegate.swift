import UIKit
import ViperArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  private var launchRouter: LaunchRouting?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    launch(from: window)
  }
  
  private func launch(from window: UIWindow) {
    self.window = window
    let viewController = RootViewController()
    let interactor = RootInteractor(presenter: viewController)
    let router = RootRouter(
      interactor: interactor,
      viewController: viewController
    )
    router.launch(from: window)
    launchRouter = router
  }
}
