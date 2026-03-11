import Combine
import Foundation

extension AnyPublisher {
  @MainActor
  public func confineTo(_ scope: InteractorScope) -> AnyPublisher<Output, Never> {
    return assertNoFailure()
      .combineLatest(scope.isActiveStream) { value, isActive in
        (isActive, value)
      }
      .filter { isActive, value in
        isActive
      }
      .map { isActive, value in
        value
      }
      .eraseToAnyPublisher()
  }
}

extension Task {
  @MainActor
  @discardableResult
  public func cancelOnDeactivate(interactor: Interactor) -> AnyCancellableTask {
    if let activenessCancellable = interactor.activenessCancellable {
      activenessCancellable.add(task: self)
    } else {
      cancel()
      print("Subscription immediately terminated, since \(interactor) is inactive.")
    }
    return self
  }
}
