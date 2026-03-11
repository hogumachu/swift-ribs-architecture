import Combine

final class CompositeCancellable: Cancellable {
  var count: Int {
    cancellables.count
  }
  
  private var isCancelled = false
  private var cancellables = Set<AnyCancellable>()
  
  func insert(_ cancellable: AnyCancellable) {
    guard !isCancelled else {
      cancellable.cancel()
      return
    }
    cancellables.insert(cancellable)
  }
  
  func cancel() {
    guard !isCancelled else { return }
    isCancelled = true
    cancellables.forEach { $0.cancel() }
  }
}
