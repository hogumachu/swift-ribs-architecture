@testable import RIBsArchitecture

import UIKit
import Testing

struct LaunchRouterTests {
  @Test
  @MainActor
  func testLaunchFromWindow() {
    let interactor = InteractableMock()
    let viewController = ViewControllableMock()
    let router = LaunchRouter(interactor: interactor, viewController: viewController)
    let window = WindowMock(frame: .zero)
    
    #expect(window.rootViewController == nil)
    #expect(window.isKeyWindow == false)
    #expect(window.makeKeyAndVisibleCallCount == 0)
    #expect(interactor.activateCallCount == 0)
    
    router.launch(from: window)
    
    #expect(window.rootViewController == viewController.uiViewController)
    #expect(window.isKeyWindow)
    #expect(window.makeKeyAndVisibleCallCount == 1)
    #expect(interactor.activateCallCount == 1)
  }
}
