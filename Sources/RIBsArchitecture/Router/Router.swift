import Combine
import Foundation

open class Router<InteractorType>: Routing {
  public final var children: [any Routing] = []
  public let interactor: InteractorType
  public let interactable: Interactable
  public final var lifecycle: AnyPublisher<RouterLifecycle, Never> {
    lifecycleSubject.eraseToAnyPublisher()
  }
  
  let deinitCancellable = CompositeCancellableBag()
  
  private var isLoaded = false
  private let lifecycleSubject = PassthroughSubject<RouterLifecycle, Never>()
  private let leakDetector: LeakDetector
  
  public init(
    interactor: InteractorType,
    leakDetector: LeakDetector = .shared
  ) {
    self.interactor = interactor
    guard let inteactable = interactor as? Interactable else {
      fatalError("\(interactor) should conform to \(Interactable.self)")
    }
    self.interactable = inteactable
    self.leakDetector = leakDetector
  }
  
  @MainActor
  deinit {
    interactable.deactivate()
    if !children.isEmpty {
      detachAllChildren()
    }
    lifecycleSubject.send(completion: .finished)
    deinitCancellable.cancel()
    leakDetector.expectDeallocate(object: interactable)
  }
  
  open func didLoad() {}
  
  public final func attach(child: any Routing) {
    assert(!(children.contains { $0 === child }), "Attempt to attach child: \(child), which is already attached to \(self).")
    children.append(child)
    child.interactable.activate()
    child.load()
  }
  
  public final func detach(child: any Routing) {
    child.interactable.deactivate()
    children.removeElementByReference(child)
  }
  
  public final func load() {
    if isLoaded { return }
    isLoaded = true
    internalDidLoad()
    didLoad()
  }
  
  func internalDidLoad() {
    bindSubtreeActiveState()
    lifecycleSubject.send(.didLoad)
  }
  
  private func bindSubtreeActiveState() {
    let cancellable = interactable
      .isActiveStream
      .sink { [weak self] isActive in
        self?.setSubtree(isActive: isActive)
      }
    deinitCancellable.add(task: cancellable)
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
