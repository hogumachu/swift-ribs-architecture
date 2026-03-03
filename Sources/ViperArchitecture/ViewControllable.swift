import UIKit

@MainActor
public protocol ViewControllable: AnyObject {
  var uiViewController: UIViewController { get }
}

extension ViewControllable where Self: UIViewController {
  public var uiViewController: UIViewController { self }
}
