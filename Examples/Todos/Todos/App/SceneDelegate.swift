import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    // TODO: - Add Example
    let rootViewController = UIViewController()
    rootViewController.view.backgroundColor = .yellow
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
    self.window = window
  }
}
