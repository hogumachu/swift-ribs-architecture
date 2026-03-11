@testable import RIBsArchitecture

import Combine
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
}
