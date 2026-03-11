import Combine
import RIBsArchitecture

final class InteractorMock: Interactable {
  var isActive: Bool {
    active.value
  }
  
  var isActiveStream: AnyPublisher<Bool, Never> {
    active.eraseToAnyPublisher()
  }
  
  private let active = CurrentValueSubject<Bool, Never>(false)
  
  var activateCallCount = 0
  func activate() {
    activateCallCount += 1
    active.send(true)
  }
  
  var deactivateCallCount = 0
  func deactivate() {
    deactivateCallCount += 1
    active.send(false)
  }
}
