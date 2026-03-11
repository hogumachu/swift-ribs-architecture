import Combine
import Foundation

@MainActor
public protocol InteractorScope: AnyObject {
  var isActive: Bool { get }
  var isActiveStream: AnyPublisher<Bool, Never> { get }
}

public protocol Interactable: InteractorScope {
 func activate()
  func deactivate()
}
