@testable import RIBsArchitecture

import Combine
import Testing

struct WorkflowTests {
  @Test
  @MainActor
  func testNestedStepsDoNotRepeat() {
    var outerStep1RunCount = 0
    var outerStep2RunCount = 0
    var outerStep3RunCount = 0
    
    var innerStep1RunCount = 0
    var innerStep2RunCount = 0
    var innerStep3RunCount = 0
    
    let emptyPublisher = generateEmptyPublisher()
    
    let workflow = Workflow<String>()
    _ = workflow
      .onStep { _ in
        outerStep1RunCount += 1
        return emptyPublisher
      }
      .onStep { _, _ in
        outerStep2RunCount += 1
        return emptyPublisher
      }
      .onStep { _, _ in
        outerStep3RunCount += 1
        let innerStep: Step<String, Void, Void>? = emptyPublisher.fork(workflow)
        innerStep?
          .onStep { _, _ in
            innerStep1RunCount += 1
            return emptyPublisher
          }
          .onStep { _, _ in
            innerStep2RunCount += 1
            return emptyPublisher
          }
          .onStep { _, _ in
            innerStep3RunCount += 1
            return emptyPublisher
          }
          .commit()
        
        return emptyPublisher
      }
      .commit()
      .subscribe("Test Actionable Item")
    
    #expect(outerStep1RunCount == 1, "Outer step 1 should not have been run more than once")
    #expect(outerStep2RunCount == 1, "Outer step 2 should not have been run more than once")
    #expect(outerStep3RunCount == 1, "Outer step 3 should not have been run more than once")
    
    #expect(innerStep1RunCount == 1, "Inner step 1 should not have been run more than once")
    #expect(innerStep2RunCount == 1, "Inner step 2 should not have been run more than once")
    #expect(innerStep3RunCount == 1, "Inner step 3 should not have been run more than once")
  }
  
  @Test
  @MainActor
  func testWorkflowReceivesError() {
    struct WorkflowTestsError: Error {}
    
    let workflow = WorkflowMock()
    let emptyPublisher = generateEmptyPublisher()
    _ = workflow
      .onStep { _ in
        return emptyPublisher
      }
      .onStep { _, _ in
        return emptyPublisher
      }
      .onStep {  _, _ -> AnyPublisher<(Void, Void), Error> in
        return Fail(error: WorkflowTestsError()).eraseToAnyPublisher()
      }
      .onStep { _, _ in
        return emptyPublisher
      }
      .commit()
      .subscribe(())
    
    #expect(workflow.didCompleteCallCount == 0)
    #expect(workflow.didForkCallCount == 0)
    #expect(workflow.didReceiveErrorCallCount == 1)
    #expect(workflow.didReceiveErrorError is WorkflowTestsError)
  }
  
  @Test
  @MainActor
  func testWorkflowDidComplete() {
    let workflow = WorkflowMock()
    let emptyPublisher = generateEmptyPublisher()
    _ = workflow
      .onStep { _ in
        return emptyPublisher
      }
      .onStep { _, _ in
        return emptyPublisher
      }
      .onStep { _, _ in
        return emptyPublisher
      }
      .commit()
      .subscribe(())
    
    #expect(workflow.didCompleteCallCount == 1)
    #expect(workflow.didForkCallCount == 0)
    #expect(workflow.didReceiveErrorCallCount == 0)
    #expect(workflow.didReceiveErrorError == nil)
  }
  
  @Test
  @MainActor
  func testWorkflowDidFork() {
    let workflow = WorkflowMock()
    let emptyPublisher = generateEmptyPublisher()
    _ = workflow
      .onStep { _ in
        return emptyPublisher
      }
      .onStep { _, _ in
        return emptyPublisher
      }
      .onStep { _, _ in
        return emptyPublisher
      }
      .onStep { _, _ in
        let forkedStep: Step<Void, Void, Void>? = emptyPublisher.fork(workflow)
        forkedStep?
          .onStep { _, _ in
              return emptyPublisher
          }
          .commit()
        return emptyPublisher
      }
      .commit()
      .subscribe(())
    
    #expect(workflow.didCompleteCallCount == 1)
    #expect(workflow.didForkCallCount == 1)
    #expect(workflow.didReceiveErrorCallCount == 0)
    #expect(workflow.didReceiveErrorError == nil)
  }
  
  @Test
  @MainActor
  func testForkVerifySingleInvocationAtRoot() {
    let workflow = WorkflowMock()
    let emptyPublisher = generateEmptyPublisher()
    
    var rootCallCount = 0
    let rootStep = workflow
      .onStep { _ in
        rootCallCount += 1
        return emptyPublisher
      }
    
    let firstFork: Step<Void, Void, Void>? = rootStep.asPublisher().fork(workflow)
    _ = firstFork?
      .onStep { _, _ in
        return generateEmptyPublisher()
      }
      .commit()
    
    let secondFork: Step<Void, Void, Void>? = rootStep.asPublisher().fork(workflow)
    _ = secondFork?
      .onStep { _, _ in
        return generateEmptyPublisher()
      }
      .commit()
    
    #expect(rootCallCount == 0)
    
    _ = workflow.subscribe(())
    
    #expect(rootCallCount == 1)
  }
  
  // MARK: - Helper
  
  private func generateEmptyPublisher() -> AnyPublisher<Result<(Void, Void), Error>.Publisher.Output, Error> {
    return Just(((), ())).setFailureType(to: Error.self).eraseToAnyPublisher()
  }
}
