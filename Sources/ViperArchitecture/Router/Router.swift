import Foundation

open class Router<InteractorType>: Routing {
  public final var children: [any Routing] = []
  public let interactor: InteractorType
  public let interactable: Interactable
  
  private var isLoaded = false
  
  public init(interactor: InteractorType) {
    self.interactor = interactor
    guard let inteactable = interactor as? Interactable else {
      fatalError("\(interactor) should conform to \(Interactable.self)")
    }
    self.interactable = inteactable
  }
  
  @MainActor
  deinit {
    interactable.deactivate()
    if !children.isEmpty {
      detachAllChildren()
    }
  }
  
  public func attach(child: any Routing) {
    children.append(child)
    child.interactable.activate()
    child.load()
  }
  
  public func detach(child: any Routing) {
    child.interactable.deactivate()
    children.removeElementByReference(child)
  }
  
  public func load() {
    if isLoaded { return }
    isLoaded = true
  }
  
  private func detachAllChildren() {
    children.forEach(detach)
  }
}
