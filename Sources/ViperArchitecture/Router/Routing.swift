import Foundation

@MainActor
public protocol Routing: AnyObject {
  associatedtype InteractorType: Interactable
  
  var children: [any Routing] { get }
  var interactor: InteractorType { get }
  
  func attach(child: any Routing)
  func detach(child: any Routing)
  func load()
}
