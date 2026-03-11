@testable import RIBsArchitecture

import Combine
import Testing

struct WorkerTests {
  @Test
  @MainActor
  func testDidStartOnceOnlyBoundToInteractor() async throws {
    let worker = WorkerMock()
    let interactor = InteractorMock()
    
    #expect(worker.isStarted == false)
    #expect(worker.didStartCallCount == 0)
    #expect(worker.didStopCallCount == 0)
    
    worker.start(interactor)
    #expect(worker.isStarted)
    #expect(worker.didStartCallCount == 0)
    #expect(worker.didStopCallCount == 0)
    
    interactor.activate()
    #expect(worker.isStarted)
    #expect(worker.didStartCallCount == 1)
    #expect(worker.didStopCallCount == 0)
    
    interactor.deactivate()
    #expect(worker.isStarted)
    #expect(worker.didStartCallCount == 1)
    #expect(worker.didStopCallCount == 1)
    
    worker.start(interactor)
    #expect(worker.isStarted)
    #expect(worker.didStartCallCount == 1)
    #expect(worker.didStopCallCount == 1)
    
    interactor.activate()
    #expect(worker.isStarted)
    #expect(worker.didStartCallCount == 2)
    #expect(worker.didStopCallCount == 1)
    
    worker.stop()
    #expect(worker.isStarted == false)
    #expect(worker.didStartCallCount == 2)
    #expect(worker.didStopCallCount == 2)

    worker.stop()
    #expect(worker.isStarted == false)
    #expect(worker.didStartCallCount == 2)
    #expect(worker.didStopCallCount == 2)
  }
  
  @Test
  @MainActor
  func testStartStopLifecycle() {
    var cancellables = Set<AnyCancellable>()
    let worker = WorkerMock()
    let interactor = InteractorMock()
    
    worker.isStartedStream
      .prefix(1)
      .sink(receiveValue: { #expect($0 == false )} )
      .store(in: &cancellables)
    
    interactor.activate()
    worker.start(interactor)
    
    worker.isStartedStream
      .prefix(1)
      .sink(receiveValue: { #expect($0)} )
      .store(in: &cancellables)
    
    worker.stop()
    
    worker.isStartedStream
      .prefix(1)
      .sink(receiveValue: { #expect($0 == false )} )
      .store(in: &cancellables)
  }
}
