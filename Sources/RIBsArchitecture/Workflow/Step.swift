import Combine
import Foundation

open class Step<
  WorkflowActionableItemType,
  ActionableItemType,
  ValueType
> {
  private let workflow: Workflow<WorkflowActionableItemType>
  private var publisher: AnyPublisher<(ActionableItemType, ValueType), Error>
  
  init(
    workflow: Workflow<WorkflowActionableItemType>,
    publisher: AnyPublisher<(ActionableItemType, ValueType), Error>
  ) {
    self.workflow = workflow
    self.publisher = publisher
  }
  
  @MainActor
  public final func onStep<NextActionableItemType ,NextValueType>(
    _ onStep: @escaping (ActionableItemType, ValueType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error>
  ) -> Step<WorkflowActionableItemType, NextActionableItemType, NextValueType> {
    let confinedNextStep = publisher
      .map { actionableItem, value -> AnyPublisher<(Bool, ActionableItemType, ValueType), Error> in
        if let interactor = actionableItem as? Interactable {
          return interactor
            .isActiveStream
            .map { isActive in
              (isActive, actionableItem, value)
            }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        } else {
          return Just((true, actionableItem, value))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
      }
      .switchToLatest()
      .filter { isActive, _, _ in
        isActive
      }
      .prefix(1)
      .map { _, actionableItem, value in
        onStep(actionableItem, value)
      }
      .switchToLatest()
      .prefix(1)
      .share()
      .eraseToAnyPublisher()
    return Step<WorkflowActionableItemType, NextActionableItemType, NextValueType>(
      workflow: workflow, publisher: confinedNextStep
    )
  }
  
  public final func onError(
    _ onError: @escaping ((Error) -> ())
  ) -> Step<WorkflowActionableItemType, ActionableItemType, ValueType> {
    publisher = publisher
      .handleEvents(receiveCompletion: { result in
        if case let .failure(error) = result {
          onError(error)
        }
      })
      .eraseToAnyPublisher()
    return self
  }
  
  @discardableResult
  public final func commit() -> Workflow<WorkflowActionableItemType> {
    let cancellable = publisher
      .sink { [weak self] result in
        switch result {
        case .finished:
          self?.workflow.didCompleteIfNotYet()
          
        case let .failure(error):
          self?.workflow.didReceiveError(error)
        }
      } receiveValue: { _ in }
    
    workflow.compositeCancellable.insert(cancellable)
    return workflow
  }
  
  public final func asPublisher() -> AnyPublisher<(ActionableItemType, ValueType), Error> {
    publisher
  }
}
