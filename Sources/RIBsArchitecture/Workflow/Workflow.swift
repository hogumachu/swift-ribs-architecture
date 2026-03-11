import Combine
import Foundation

open class Workflow<ActionableItemType> {
  open func didComplete() {}
  open func didFork() {}
  open func didReceiveError(_ error: Error) {}
  
  let compositeCancellable = CompositeCancellable()
  
  private let subject = PassthroughSubject<(ActionableItemType, ()), Error>()
  private var didInvokeComplete = false
  
  public init() {}
  
  @MainActor
  public final func onStep<NextActionableItemType, NextValueType>(
    _ onStep: @escaping (ActionableItemType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error>
  ) -> Step<ActionableItemType, NextActionableItemType, NextValueType> {
    return Step(
      workflow: self,
      publisher: subject.prefix(1).eraseToAnyPublisher()
    )
    .onStep { actionableItem, _ in
      onStep(actionableItem)
    }
  }
  
  public final func subscribe(_ actionableItem: ActionableItemType) -> Cancellable {
    guard compositeCancellable.count > 0 else {
      assertionFailure("Attempt to subscribe to \(self) before it is comitted.")
      return CompositeCancellable()
    }
    subject.send((actionableItem, ()))
    return compositeCancellable
  }
  
  func didCompleteIfNotYet() {
    if didInvokeComplete {
      return
    }
    didInvokeComplete = true
    didComplete()
  }
}
