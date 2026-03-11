import RIBsArchitecture

final class WorkflowMock: Workflow<Void> {
  var didCompleteCallCount = 0
  override func didComplete() {
    didCompleteCallCount += 1
  }
  
  var didForkCallCount = 0
  override func didFork() {
    didForkCallCount += 1
  }
  
  var didReceiveErrorCallCount = 0
  var didReceiveErrorError: (any Error)?
  override func didReceiveError(_ error: any Error) {
    didReceiveErrorCallCount += 1
    didReceiveErrorError = error
  }
}
