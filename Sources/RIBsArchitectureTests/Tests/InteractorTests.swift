@testable import RIBsArchitecture

import Combine
import Foundation
import Testing

struct InteractorTests {
  @Test
  @MainActor
  func testInteractorIsInactiveByDefault() {
    let interactor = InteractorMock()
    #expect(interactor.isActive == false)
    _ = interactor.isActiveStream.sink { isActive in
      #expect(isActive == false)
    }
  }
  
  @Test
  @MainActor
  func testIsActiveWhenStartedIsTrue() {
    let interactor = InteractorMock()
    interactor.activate()
    #expect(interactor.isActive)
    _ = interactor.isActiveStream.sink { isActive in
      #expect(isActive)
    }
  }
  
  @Test
  @MainActor
  func testIsActiveWhenDeactivatedIsFalse() {
    let interactor = InteractorMock()
    interactor.activate()
    interactor.deactivate()
    #expect(interactor.isActive == false)
    _ = interactor.isActiveStream.sink { isActive in
      #expect(isActive == false)
    }
  }
  
  @Test
  @MainActor
  func testDidBecomeActiveIsCalledWhenStarted() {
    let interactor = InteractorMock()
    interactor.activate()
    #expect(interactor.didBecomeActiveCallCount == 1)
  }
  
  @Test
  @MainActor
  func testDidBecomeActiveIsNotCalledWhenAlreadyActive() {
    let interactor = InteractorMock()
    interactor.activate()
    #expect(interactor.didBecomeActiveCallCount == 1)
    
    interactor.activate()
    #expect(interactor.didBecomeActiveCallCount == 1)
  }
  
  @Test
  @MainActor
  func testWillResignActiveIsCalledWhenDeactivated() {
    let interactor = InteractorMock()
    interactor.activate()
    interactor.deactivate()
    
    #expect(interactor.willResignActiveCallCount == 1)
  }
  
  @Test
  @MainActor
  func testWillResignActiveIsNotCalledWhenAlreadyInactive() {
    let interactor = InteractorMock()
    interactor.activate()
    interactor.deactivate()
    #expect(interactor.willResignActiveCallCount == 1)
    
    interactor.deactivate()
    #expect(interactor.willResignActiveCallCount == 1)
  }
  
  @Test
  @MainActor
  func testIsActiveStreamCompletedOnInteractorDeinit() {
    var interactor: InteractorMock? = InteractorMock()
    var isActiveStreamCompleted = false
    var cancellables = Set<AnyCancellable>()
    interactor?.activate()
    interactor?.isActiveStream
      .sink { _ in
        isActiveStreamCompleted = true
      } receiveValue: { _ in }
      .store(in: &cancellables)
    
    interactor = nil
    #expect(isActiveStreamCompleted)
  }
  
  @Test
  @MainActor
  func testObservableAttachedToInactiveInteactorIsDisposedImmediately() {
    let interactor = InteractorMock()
    var onDisposeCalled = false
    let subjectEmiitingValues = PassthroughSubject<Int, Never>()
    let observable = subjectEmiitingValues.eraseToAnyPublisher()
      .handleEvents(
        receiveCompletion: { _ in onDisposeCalled = true },
        receiveCancel: { onDisposeCalled = true }
      )
    
    observable.sink { _ in }.cancelOnDeactivate(interactor: interactor)
    #expect(onDisposeCalled)
  }
  
  @Test
  @MainActor
  func testObservableIsDisposedOnInteractorDeactivation() {
    let interactor = InteractorMock()
    var onDisposeCalled = false
    let subjectEmiitingValues = PassthroughSubject<Int, Never>()
    let observable = subjectEmiitingValues.eraseToAnyPublisher()
      .handleEvents(
        receiveCompletion: { _ in onDisposeCalled = true },
        receiveCancel: { onDisposeCalled = true }
      )
    interactor.activate()
    observable.sink { _ in }.cancelOnDeactivate(interactor: interactor)
    
    interactor.deactivate()
    #expect(onDisposeCalled)
  }
  
  @Test
  @MainActor
  func testObservableIsDisposedOnInteractorDeinit() {
    var interactor: InteractorMock! = InteractorMock()
    var onDisposeCalled = false
    let subjectEmiitingValues = PassthroughSubject<Int, Never>()
    let observable = subjectEmiitingValues.eraseToAnyPublisher()
      .handleEvents(
        receiveCompletion: { _ in onDisposeCalled = true },
        receiveCancel: { onDisposeCalled = true }
      )
    interactor?.activate()
    observable.sink { _ in }.cancelOnDeactivate(interactor: interactor)
    #expect(onDisposeCalled == false)
    
    interactor = nil
    #expect(onDisposeCalled)
  }
  
  @Test
  @MainActor
  func testObservableConfinedToInteractorOnlyEmitsValueWhenInteractorIsActive() {
    let interactor = InteractorMock()
    var emittedValue: Int?
    var cancellables = Set<AnyCancellable>()
    let subjectEmiitingValues = PassthroughSubject<Int, Never>()
    let confinedObservable = subjectEmiitingValues.eraseToAnyPublisher().confineTo(interactor)
    let _ = confinedObservable.confineTo(interactor)
    confinedObservable.sink { value in
      emittedValue = value
    }
    .store(in: &cancellables)
    
    subjectEmiitingValues.send(1)
    #expect(emittedValue == nil)
    
    interactor.activate()
    subjectEmiitingValues.send(2)
    
    #expect(emittedValue != nil)
    #expect(emittedValue == 2)
  }
}
