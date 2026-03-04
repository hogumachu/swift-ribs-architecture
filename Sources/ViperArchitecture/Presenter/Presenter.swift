import Foundation

open class Presenter<ViewController: ViewControllable>: Presentable {
  public let viewController: ViewController
  
  public init(viewController: ViewController) {
    self.viewController = viewController
  }
}
