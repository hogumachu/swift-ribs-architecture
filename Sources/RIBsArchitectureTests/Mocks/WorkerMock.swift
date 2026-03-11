import Foundation
import RIBsArchitecture

final class WorkerMock: Worker {
  var didStartCallCount = 0
  override func didStart(_ interactorScope: any InteractorScope) {
    super.didStart(interactorScope)
    didStartCallCount += 1
  }
  
  var didStopCallCount = 0
  override func didStop() {
    super.didStop()
    didStopCallCount += 1
  }
}
