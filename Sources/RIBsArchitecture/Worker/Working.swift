import Combine

@MainActor
public protocol Working: AnyObject {
  var isStarted: Bool { get }
  var isStartedStream: AnyPublisher<Bool, Never> { get }
  
  func start(_ interactorScope: InteractorScope)
  func stop()
}
