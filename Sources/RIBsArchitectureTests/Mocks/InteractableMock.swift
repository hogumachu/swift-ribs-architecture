import Combine
import RIBsArchitecture

final class InteractableMock: Interactable {
  var isActiveSetCallCount = 0
  var isActive = false {
    didSet {
      isActiveSetCallCount += 1
    }
  }
  
  var isActiveStream: AnyPublisher<Bool, Never> {
    isActiveStreamSubject.eraseToAnyPublisher()
  }
  
  var isActiveStreamSubjectSetCallCount = 0
  var isActiveStreamSubject = PassthroughSubject<Bool, Never>() {
    didSet {
      isActiveStreamSubjectSetCallCount += 1 }
    
  }
  
  var activateCallCount = 0
  var activateHandler: (() -> Void)?
  func activate() {
    activateCallCount += 1
    activateHandler?()
  }
  
  var deactivateCallCount = 0
  var deactivateHandler: (() -> Void)?
  func deactivate() {
    deactivateCallCount += 1
    deactivateHandler?()
  }
}
