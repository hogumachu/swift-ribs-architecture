import UIKit

public protocol LaunchRouting: ViewableRouting {
  func launch(from window: UIWindow)
}
