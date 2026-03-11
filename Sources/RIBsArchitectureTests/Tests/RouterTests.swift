@testable import RIBsArchitecture

import Combine
import Foundation
import Testing

struct RouterTests {
  @Test
  @MainActor
  func testLoadVerifyLifecyclePublisher() {
    let interactor = InteractorMock()
    var router: Router? = Router(interactor: interactor)
    var currentLifecycle: RouterLifecycle?
    var didComplete = false
    var cancellables = Set<AnyCancellable>()
    router?
      .lifecycle
      .sink { _ in
        currentLifecycle = nil
        didComplete = true
      } receiveValue: { lifecycle in
        currentLifecycle = lifecycle
      }
      .store(in: &cancellables)
    
    #expect(currentLifecycle == nil)
    #expect(didComplete == false)
    
    router?.load()
    
    #expect(currentLifecycle == .didLoad)
    #expect(didComplete == false)
    
    router = nil
    
    #expect(currentLifecycle == nil)
    #expect(didComplete)
  }
  
  @Test
  @MainActor
  func testAttachChild() {
    let intector = InteractableMock()
    let router = Router(interactor: intector)
    let childInteractor = InteractableMock()
    let childRouter = RouterMock(interactor: childInteractor)
    
    router.attach(child: childRouter)
    
    #expect(router.children.count == 1)
    #expect(childInteractor.activateCallCount == 1)
    #expect(childRouter.loadCallCount == 1)
  }
  
  @Test
  @MainActor
  func testAttachChildActivatesSubtreeOfTheChild() {
    let intector = InteractableMock()
    let router = Router(interactor: intector)
    let childInteractor = InteractableMock()
    let childRouter = Router(interactor: childInteractor)
    let grandChildInteractor = InteractableMock()
    let grandChildRouter = RouterMock(interactor: grandChildInteractor)
    childRouter.attach(child: grandChildRouter)
    router.load()
    
    router.attach(child: childRouter)
    
    #expect(grandChildInteractor.activateCallCount == 1)
    #expect(grandChildRouter.loadCallCount == 1)
  }
  
  @Test
  @MainActor
  func testDetachChild() {
    let intector = InteractableMock()
    let router = Router(interactor: intector)
    let childInteractor = InteractableMock()
    let childRouter = RouterMock(interactor: childInteractor)
    router.attach(child: childRouter)
    
    router.detach(child: childRouter)
    
    #expect(router.children.count == 0)
    #expect(childInteractor.deactivateCallCount == 1)
  }
  
  @Test
  @MainActor
  func testDetachChildDeactivatesSubtreeOfTheChild() {
    let intector = InteractableMock()
    let router = Router(interactor: intector)
    let childInteractor = Interactor()
    let childRouter = Router(interactor: childInteractor)
    let grandChildInteractor = InteractableMock()
    let grandChildRouter = RouterMock(interactor: grandChildInteractor)
    router.load()
    router.attach(child: childRouter)
    childRouter.attach(child: grandChildRouter)
    grandChildInteractor.isActive = true
    
    router.detach(child: childRouter)
    
    #expect(grandChildInteractor.deactivateCallCount == 1)
  }
  
  @Test
  @MainActor
  func testDeinitTriggersLeakDetection() async {
    let leakDetector = LeakDetectorMock()
    LeakDetector.setInstance(leakDetector)
    let interactor = InteractableMock()
    var router: Router<InteractableMock>!
    router = Router(interactor: interactor)
    router.load()
    
    router = nil
    #expect(leakDetector.expectDeallocateCallCount == 1)
  }
}
