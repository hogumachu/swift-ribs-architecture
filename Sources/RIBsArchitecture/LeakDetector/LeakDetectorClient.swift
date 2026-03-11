import UIKit

public struct LeakDetectorClient: Sendable {
  public var expectDeallocate: @Sendable (_ object: AnyObject, _ time: TimeInterval) -> Task<Void, Never>
  public var expectViewControllerDisappear: @Sendable (_ viewController: UIViewController, _ time: TimeInterval) -> Task<Void, Never>
}

extension LeakDetectorClient {
  @discardableResult
  public func expectDeallocate(
    _ object: AnyObject,
    inTime time: TimeInterval = LeakDefaultExpectationTime.deallocation
  ) -> Task<Void, Never>{
    return expectDeallocate(object, time)
  }
  
  @discardableResult
  public func expectViewControllerDisappear(
    _ viewController: UIViewController,
    inTime time: TimeInterval = LeakDefaultExpectationTime.viewDisappear
  ) -> Task<Void, Never>{
    expectViewControllerDisappear(viewController, time)
  }
}
