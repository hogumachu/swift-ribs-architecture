import Combine
import Foundation

extension Publisher {
  public func fork<WorkflowActionableItemType, ActionableItemType, ValueType>(_ workflow: Workflow<WorkflowActionableItemType>) -> Step<WorkflowActionableItemType, ActionableItemType, ValueType>? {
    if let stepPublisher = self as? AnyPublisher<(ActionableItemType, ValueType), Error> {
      workflow.didFork()
      return Step(workflow: workflow, publisher: stepPublisher)
    }
    return nil
  }
}

extension AnyCancellable {
  public func cancelWith<ActionableItemType>(workflow: Workflow<ActionableItemType>) {
    workflow.compositeCancellable.insert(self)
  }
}
