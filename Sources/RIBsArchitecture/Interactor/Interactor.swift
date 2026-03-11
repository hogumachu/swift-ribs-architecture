import Combine
import Foundation

open class Interactor: Interactable {
  public final var isActive: Bool {
    isActiveSubject.value
  }
  
  public final var isActiveStream: AnyPublisher<Bool, Never> {
    isActiveSubject.removeDuplicates().eraseToAnyPublisher()
  }
  
  private(set) var activenessCancellable: CompositeCancellable?
  
  private let isActiveSubject = CurrentValueSubject<Bool, Never>(false)
  
  public init() {}
  
  @MainActor
  deinit {
    if isActive {
      deactivate()
    }
    isActiveSubject.send(completion: .finished)
  }
  
  public final func activate() {
    if isActive { return }
    activenessCancellable = .init()
    isActiveSubject.send(true)
    didBecomeActive()
  }
  
  public final func deactivate() {
    if !isActive { return }
    willResignActive()
    activenessCancellable?.cancel()
    activenessCancellable = nil
    isActiveSubject.send(false)
  }
    
  open func didBecomeActive() {}
  open func willResignActive() {}
}
