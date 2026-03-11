@testable import RIBsArchitecture

import Combine
import Testing

struct PresentableInteractorTests {
  @Test(
    "Deinit Does Not Leak Presenter",
    arguments: [3, 5, 10, 100]
  )
  func testDeinitDoesNotLeakPresenter(count: Int) async {
    let leakDetector = await LeakDetector()
    await withLeakDetector(leakDetector) {
      let presenter = PresenterMock()
      var interactors = (1...count).map {
        _ in PresentableInteractor(presenter: presenter)
      }
      var status = LeakDetectionStatus.didComplete
      var cancellable = Set<AnyCancellable>()
      leakDetector.status.sink { newStatus in
        status = newStatus
      }
      .store(in: &cancellable)
      
      #expect(status == .didComplete)
      
      interactors.removeAll()
      
      #expect(status == .inProgress)
    }
  }
}
