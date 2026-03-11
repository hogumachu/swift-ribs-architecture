import RIBsArchitecture
import UIKit

final class ViewControllableMock: ViewControllable {
  var uiViewController: UIViewController { viewControllerMock }
  var viewControllerMock = ViewControllerMock()
}

final class ViewControllerMock: UIViewController {}
