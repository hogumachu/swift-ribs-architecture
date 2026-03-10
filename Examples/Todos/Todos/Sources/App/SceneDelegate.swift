import RIBsArchitecture
import UIKit

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
    let router = RootBuilder().build()
    router.launch(from: window)
    launchRouter = router
  }
}
