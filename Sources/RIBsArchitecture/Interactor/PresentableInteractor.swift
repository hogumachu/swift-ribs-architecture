import Foundation

open class PresentableInteractor<PresenterType>: Interactor {
  public let presenter: PresenterType
  
  public init(presenter: PresenterType) {
    self.presenter = presenter
  }
  
  @MainActor
  deinit {
    LeakDetector.shared.expectDeallocate(object: presenter as AnyObject)
  }
}
