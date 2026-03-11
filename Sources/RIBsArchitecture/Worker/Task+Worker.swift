import Foundation

extension Task {
  @MainActor
  @discardableResult
  public func cancelOnStop(_ worker: Worker) -> Task {
    if let compositeCancellable = worker.cancellable {
      compositeCancellable.add(task: self)
    } else {
      cancel()
      print("Subscription immediately terminated, since \(worker) is stopped.")
    }
    return self
  }
}
