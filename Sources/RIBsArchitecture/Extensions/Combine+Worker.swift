import Combine
import Foundation

extension AnyCancellable {
  @MainActor
  @discardableResult
  public func cancelOnStop(_ worker: Worker) -> AnyCancellable {
    if let compositeCancellable = worker.cancellable {
      compositeCancellable.insert(self)
    } else {
      cancel()
      print("Subscription immediately terminated, since \(worker) is stopped.")
    }
    return self
  }
}
