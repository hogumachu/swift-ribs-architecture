@testable import RIBsArchitecture

import Combine
import Testing
import UIKit

struct ViewableRouterTests {
  @Test
  @MainActor
  func testLeakDetection() {
    let leakDetector = LeakDetectorMock()
    LeakDetector.setInstance(leakDetector)
    let interactor = PresentableInteractor(presenter: PresenterMock())
    let viewController = ViewControllableMock()
    let router = ViewableRouter(interactor: interactor, viewController: viewController)
    router.load()
    
    interactor.deactivate()
    
    #expect(leakDetector.expectViewControllerDisappearCallCount == 1)
    #expect(leakDetector.expectViewControllerDisappearViewController == viewController.uiViewController)
  }
  
  @Test
  @MainActor
  func testDeinitTriggersLeakDetection() {
    let leakDetector = LeakDetectorMock()
    LeakDetector.setInstance(leakDetector)
    let interactor = PresentableInteractor(presenter: PresenterMock())
    let viewController = ViewControllableMock()
    var router: ViewableRouter! = ViewableRouter(interactor: interactor, viewController: viewController)
    router.load()
    
    router = nil
    
    #expect(leakDetector.expectDeallocateCallCount == 2)
  }
}
