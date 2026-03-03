import Foundation

@MainActor
public protocol Interactable: AnyObject {
  func activate()
  func deactivate()
}
