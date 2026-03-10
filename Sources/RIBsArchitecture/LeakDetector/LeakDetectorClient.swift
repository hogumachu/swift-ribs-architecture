import UIKit

public struct LeakDetectorClient: Sendable {
  public var expectDeallocate: @Sendable (_ object: AnyObject, _ time: TimeInterval) -> Void
  public var expectViewControllerDisappear: @Sendable (_ viewController: UIViewController, _ time: TimeInterval) -> Void
}

extension LeakDetectorClient {
  public func expectDeallocate(
    _ object: AnyObject,
    inTime time: TimeInterval = LeakDefaultExpectationTime.deallocation
  ) {
    expectDeallocate(object, time)
  }
  
  public func expectViewControllerDisappear(
    _ viewController: UIViewController,
    inTime time: TimeInterval = LeakDefaultExpectationTime.viewDisappear
  ) {
    expectViewControllerDisappear(viewController, time)
  }
}
