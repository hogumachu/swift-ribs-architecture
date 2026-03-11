@testable import RIBsArchitecture

import Combine
import Testing

struct PresentableInteractorTests {
  @Test
  @MainActor
  func testDeinitDoesNotLeakPresenter() {
    let leakDetector = LeakDetector()
    let presenter = PresenterMock()
    var interactor: PresentableInteractor<PresenterMock>!
    interactor = PresentableInteractor(presenter: presenter, leakDetector: leakDetector)
    var status = LeakDetectionStatus.didComplete
    var cancellable = Set<AnyCancellable>()
    leakDetector.status.sink { newStatus in
      status = newStatus
    }
    .store(in: &cancellable)
    
    #expect(status == .didComplete)
    
    interactor = nil
    
    #expect(status == .inProgress)
  }
}
