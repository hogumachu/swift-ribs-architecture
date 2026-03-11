import Combine
import Foundation
import RIBsDependency

open class Router<InteractorType>: Routing {
  public final var children: [any Routing] = []
  public let interactor: InteractorType
  public let interactable: Interactable
  
  let deinitCancellable = CompositeCancellable()
  
  private var isLoaded = false
  
  @Dependency(\.leakDetectorClient) private var leakDetectorClient
  
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
    deinitCancellable.cancel()
    leakDetectorClient.expectDeallocate(interactable)
  }
  
  open func didLoad() {}
  
  public final func attach(child: any Routing) {
    assert(!(children.contains { $0 === child }), "Attempt to attach child: \(child), which is already attached to \(self).")
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
    internalDidLoad()
    didLoad()
  }
  
  func internalDidLoad() {
    bindSubtreeActiveState()
  }
  
  private func bindSubtreeActiveState() {
    let cancellable = interactable
      .isActiveStream
      .sink { [weak self] isActive in
        self?.setSubtree(isActive: isActive)
      }
    deinitCancellable.insert(cancellable)
  }
  
  private func detachAllChildren() {
    children.forEach(detach)
  }
  
  private func iterateSubtree(_ root: Routing, execute: (_ node: Routing) -> ()) {
    execute(root)
    
    root.children.forEach {
      iterateSubtree($0, execute: execute)
    }
  }
  
  private func setSubtree(isActive: Bool) {
    if isActive {
      iterateSubtree(self) { router in
        if !router.interactable.isActive {
          router.interactable.activate()
        }
      }
    } else {
      iterateSubtree(self) { router in
        if router.interactable.isActive {
          router.interactable.deactivate()
        }
      }
    }
  }
}
