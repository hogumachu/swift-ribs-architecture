import Combine
import RIBsArchitecture

final class InteractorMock: Interactor {
  var didBecomeActiveCallCount = 0
  var didBecomeActiveHandler: (() -> Void)?
  override func didBecomeActive() {
    didBecomeActiveCallCount += 1
    super.didBecomeActive()
    didBecomeActiveHandler?()
  }
  
  var willResignActiveCallCount = 0
  var willResignActiveHandler: (() -> Void)?
  override func willResignActive() {
    willResignActiveCallCount += 1
    super.willResignActive()
    willResignActiveHandler?()
  }
}
