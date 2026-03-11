import Combine
import RIBsArchitecture

final class RouterMock: Routing {
  var children: [any Routing]
  var interactable: any Interactable
  
  var lifecycle: AnyPublisher<RouterLifecycle, Never> {
    Just(.didLoad).eraseToAnyPublisher()
  }
  
  init(interactor: any Interactable) {
    self.interactable = interactor
    self.children = []
  }
  
  var attachCallCount = 0
  var attachChild: (any Routing)?
  func attach(child: any Routing) {
    attachCallCount += 1
    attachChild = child
  }
  
  var detachCallCount = 0
  var detachChild: (any Routing)?
  func detach(child: any Routing) {
    detachCallCount += 1
    detachChild = child
  }
  
  var loadCallCount = 0
  func load() {
    loadCallCount += 1
  }
}
