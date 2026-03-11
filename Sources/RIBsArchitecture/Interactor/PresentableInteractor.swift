import Foundation

open class PresentableInteractor<PresenterType>: Interactor {
  public let presenter: PresenterType
  
  private let leakDetector: LeakDetector
  
  public init(
    presenter: PresenterType,
    leakDetector: LeakDetector = .shared
  ) {
    self.presenter = presenter
    self.leakDetector = leakDetector
  }
  
  @MainActor
  deinit {
    leakDetector.expectDeallocate(object: presenter as AnyObject)
  }
}
