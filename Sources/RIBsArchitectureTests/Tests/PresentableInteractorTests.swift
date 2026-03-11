@testable import RIBsArchitecture

import Combine
import Testing

struct PresentableInteractorTests {
  @Test
  @MainActor
  func testDeinitDoesNotLeakPresenter() {
    final class PresenterMock {}
    let leakDetector = LeakDetector()
    LeakDetector.setInstance(leakDetector)
    let presenter = PresenterMock()
    var interactor: PresentableInteractor<PresenterMock>!
    interactor = PresentableInteractor(presenter: presenter)
    var status = LeakDetectionStatus.didComplete
    var cancellable = Set<AnyCancellable>()
    LeakDetector.shared.status.sink { newStatus in
      status = newStatus
    }
    .store(in: &cancellable)
    
    #expect(status == .didComplete)
    
    interactor = nil
    
    #expect(status == .inProgress)
  }
}
