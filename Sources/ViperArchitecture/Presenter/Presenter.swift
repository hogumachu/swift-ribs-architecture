import Foundation

open class Presenter<ViewController>: Presentable {
  public let viewController: ViewController
  
  public init(viewController: ViewController) {
    self.viewController = viewController
  }
}
