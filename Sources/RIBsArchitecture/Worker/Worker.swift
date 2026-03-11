import Combine
import Foundation

open class Worker: Working {
  public final var isStarted: Bool {
    isStartedSubject.value
  }
  
  public final var isStartedStream: AnyPublisher<Bool, Never> {
    isStartedSubject
      .removeDuplicates()
      .eraseToAnyPublisher()
  }
  
  var cancellable: CompositeCancellable?
  
  private let isStartedSubject = CurrentValueSubject<Bool, Never>(false)
  private var interactorBindingCancellable: AnyCancellable?
  
  public init() {}
  
  @MainActor
  deinit {
    stop()
    unbindInteractor()
    isStartedSubject.send(completion: .finished)
  }
  
  open func didStart(_ interactorScope: InteractorScope) {}
  open func didStop() {}
  
  public final func start(_ interactorScope: InteractorScope) {
    if isStarted {
      return
    }
    stop()
    
    isStartedSubject.send(true)
    let weakInteractorScope = WeakInteractorScope(sourceScope: interactorScope)
    bind(to: weakInteractorScope)
  }
  
  public final func stop() {
    if !isStarted {
      return
    }
    isStartedSubject.send(false)
    executeStop()
  }
  
  private func bind(to interactorScope: InteractorScope) {
    unbindInteractor()
    
    interactorBindingCancellable = interactorScope
      .isActiveStream
      .sink { [weak self] isActive in
        if isActive {
          if self?.isStarted == true {
            self?.executeStart(interactorScope)
          }
        } else {
          self?.executeStop()
        }
      }
  }
  
  private func executeStart(_ interactorScope: InteractorScope) {
    cancellable = CompositeCancellable()
    didStart(interactorScope)
  }
  
  private func executeStop() {
    guard let cancellable else {
      return
    }
    cancellable.cancel()
    self.cancellable = nil
    didStop()
  }
  
  private func unbindInteractor() {
    interactorBindingCancellable?.cancel()
    interactorBindingCancellable = nil
  }
}

private final class WeakInteractorScope: InteractorScope {
  weak var sourceScope: InteractorScope?
  
  var isActive: Bool {
    sourceScope?.isActive ?? false
  }
  
  var isActiveStream: AnyPublisher<Bool, Never> {
    sourceScope?.isActiveStream ?? Just(false).eraseToAnyPublisher()
  }
  
  init(
    sourceScope: InteractorScope
  ) {
    self.sourceScope = sourceScope
  }
}
