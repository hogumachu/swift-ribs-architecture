@testable import RIBsArchitecture

import Combine
import Testing
import UIKit

struct ViewableRouterTests {
  @Test
  @MainActor
  func testLeakDetection() {
    let leakDetector = LeakDetectorMock()
    let interactor = PresentableInteractor(
      presenter: PresenterMock(),
      leakDetector: leakDetector
    )
    let viewController = ViewControllableMock()
    let router = ViewableRouter(
      interactor: interactor,
      viewController: viewController,
      leakDetector: leakDetector
    )
    router.load()
    
    interactor.deactivate()
    
    #expect(leakDetector.expectViewControllerDisappearCallCount == 1)
    #expect(leakDetector.expectViewControllerDisappearViewController == viewController.uiViewController)
  }
  
  @Test
  @MainActor
  func testDeinitTriggersLeakDetection() {
    let leakDetector = LeakDetectorMock()
    let interactor = PresentableInteractor(
      presenter: PresenterMock(),
      leakDetector: leakDetector
    )
    let viewController = ViewControllableMock()
    var router: ViewableRouter! = ViewableRouter(
      interactor: interactor,
      viewController: viewController,
      leakDetector: leakDetector
    )
    router.load()
    
    router = nil
    
    #expect(leakDetector.expectDeallocateCallCount == 2)
  }
}
