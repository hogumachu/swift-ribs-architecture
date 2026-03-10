import Foundation

@MainActor
public protocol Routing: AnyObject {
  var children: [any Routing] { get }
  var interactable: Interactable { get }
  
  func attach(child: any Routing)
  func detach(child: any Routing)
  func load()
}
