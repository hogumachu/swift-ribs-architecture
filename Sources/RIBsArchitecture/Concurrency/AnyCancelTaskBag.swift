import Dispatch
import Foundation

public protocol AnyCancelTaskBag: AnyCancellableTask {
  func add(task: any AnyCancellableTask)
}

final class CompositeCancellableBag: AnyCancelTaskBag {
  var count: Int {
    assertMainQueue()
    return tasks.count
  }
  
  private var isCancelled = false
  private var tasks: [any AnyCancellableTask] = []
  
  init() {}
  
  func add(task: any AnyCancellableTask) {
    assertMainQueue()
    guard !isCancelled else {
      task.cancel()
      return
    }
    tasks.append(task)
  }
  
  func cancel() {
    assertMainQueue()
    guard !isCancelled else { return }
    isCancelled = true
    tasks.forEach { $0.cancel() }
    tasks.removeAll()
  }

  private func assertMainQueue() {
    dispatchPrecondition(condition: .onQueue(.main))
  }
}
