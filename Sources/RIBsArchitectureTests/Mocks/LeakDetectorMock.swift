@testable import RIBsArchitecture

import Combine
import UIKit

final class LeakDetectionHandleMock: LeakDetectionHandle {
  var cancelCallCount = 0
  func cancel() {
    cancelCallCount += 1
  }
}

final class LeakDetectorMock: LeakDetector {
  var expectDeallocateCallCount = 0
  var expectDeallocateObject: AnyObject?
  var expectDeallocateTime: TimeInterval?
  var expectDeallocateResult: (any LeakDetectionHandle)?
  override func expectDeallocate(
    object: AnyObject,
    inTime time: TimeInterval = LeakDefaultExpectationTime.deallocation
  ) -> any LeakDetectionHandle {
    expectDeallocateCallCount += 1
    expectDeallocateObject = object
    expectDeallocateTime = time
    return expectDeallocateResult ?? LeakDetectionHandleMock()
  }
  
  var expectViewControllerDisappearCallCount = 0
  var expectViewControllerDisappearViewController: UIViewController?
  var expectViewControllerDisappearTime: TimeInterval?
  var expectViewControllerDisappearResult: (any LeakDetectionHandle)?
  override func expectViewControllerDisappear(
    viewController: UIViewController,
    inTime time: TimeInterval = LeakDefaultExpectationTime.viewDisappear
  ) -> any LeakDetectionHandle {
    expectViewControllerDisappearCallCount += 1
    expectViewControllerDisappearViewController = viewController
    expectViewControllerDisappearTime = time
    return expectViewControllerDisappearResult ?? LeakDetectionHandleMock()
  }
}
