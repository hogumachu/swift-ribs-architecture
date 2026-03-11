import UIKit

final class WindowMock: UIWindow {
  override var isKeyWindow: Bool { _isKeyWindow }
  private var _isKeyWindow = false
  
  override var rootViewController: UIViewController? {
    get { _rootViewController }
    set { _rootViewController = newValue }
  }
  private var _rootViewController: UIViewController?
  
  var makeKeyAndVisibleCallCount = 0
  override func makeKeyAndVisible() {
    makeKeyAndVisibleCallCount += 1
    _isKeyWindow = true
  }
}
