import Foundation

open class Interactor: Interactable {
  public final var isActive = false
  
  public init() {}
  
  @MainActor
  deinit {
    if isActive {
      deactivate()
    }
  }
  
  public final func activate() {
    if isActive { return }
    isActive = true
    didBecomeActive()
  }
  
  public final func deactivate() {
    if !isActive { return }
    willResignActive()
    isActive = false
  }
    
  open func didBecomeActive() {}
  open func willResignActive() {}
}
