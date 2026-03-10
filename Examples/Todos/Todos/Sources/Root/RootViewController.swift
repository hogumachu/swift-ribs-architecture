import RIBsArchitecture
import UIKit

final class RootViewController:
  UIViewController,
  RootViewControllable,
  RootPresentable
{
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemPink
  }
}
