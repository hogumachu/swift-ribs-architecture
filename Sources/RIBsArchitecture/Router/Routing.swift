import Combine
import Foundation

public enum RouterLifecycle: Sendable {
  case didLoad
}

@MainActor
public protocol RouterScope: AnyObject {
  var lifecycle: AnyPublisher<RouterLifecycle, Never> { get }
}

public protocol Routing: RouterScope {
  var children: [any Routing] { get }
  var interactable: Interactable { get }
  
  func attach(child: any Routing)
  func detach(child: any Routing)
  func load()
}
