import Foundation

open class Router<Interactor: Interactable>: Routing {
  public final var children: [any Routing] = []
  public let interactor: Interactor
  
  private var isLoaded = false
  
  public init(interactor: Interactor) {
    self.interactor = interactor
  }
  
  @MainActor
  deinit {
    interactor.deactivate()
    if !children.isEmpty {
      detachAllChildren()
    }
  }
  
  public func attach(child: any Routing) {
    children.append(child)
    child.interactor.activate()
    child.load()
  }
  
  public func detach(child: any Routing) {
    child.interactor.deactivate()
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
