@testable import RIBsArchitecture

import Combine
import Testing

struct AnyCancelTaskBagTests {
  @Test
  @MainActor
  func testAddOnCancelledBagCancelsTaskAndAnyCancellableImmediately() async {
    let cancellableBag = CompositeCancellableBag()
    cancellableBag.cancel()

    final class Box: @unchecked Sendable {
      var taskCancelled = false
      var anyCancellableCancelled = false
    }
    let box = Box()

    let task = Task {
      await withTaskCancellationHandler(
        operation: {
          while !Task.isCancelled {
            await Task.yield()
          }
        },
        onCancel: {
          box.taskCancelled = true
        }
      )
    }
    cancellableBag.add(task: task)
    await Task.yield()

    let anyCancellable = AnyCancellable {
      box.anyCancellableCancelled = true
    }
    cancellableBag.add(task: anyCancellable)

    #expect(box.taskCancelled)
    #expect(box.anyCancellableCancelled)
    #expect(cancellableBag.count == 0)
  }
}
