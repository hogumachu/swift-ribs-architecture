import Foundation
import RIBsDependency

open class PresentableInteractor<PresenterType>: Interactor {
  public let presenter: PresenterType
  
  private let leakDetector: LeakDetector
  
  public init(
    presenter: PresenterType
  ) {
    @Dependency(\.leakDetectorGenerator) var leakDetectorGenerator
    self.presenter = presenter
    self.leakDetector = leakDetectorGenerator()
  }
  
  @MainActor
  deinit {
    leakDetector.expectDeallocate(object: presenter as AnyObject)
  }
}
