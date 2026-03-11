import Foundation
import RIBsDependency

open class PresentableInteractor<PresenterType>: Interactor {
  public let presenter: PresenterType
  
  @Dependency(\.leakDetectorClient) private var leakDetectorClient
  
  public init(presenter: PresenterType) {
    self.presenter = presenter
  }
  
  @MainActor
  deinit {
    leakDetectorClient.expectDeallocate(presenter as AnyObject)
  }
}
