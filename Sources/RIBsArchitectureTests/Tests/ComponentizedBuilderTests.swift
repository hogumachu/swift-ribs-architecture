@testable import RIBsArchitecture

import CwlPreconditionTesting
import Foundation
import Testing

struct ComponentizedBuilderTests {
  @Test
  @MainActor
  func testComponentForCurrentPassBuilderReturnsSameInstanceVerifyAssertion() {
    let component = ComponentizedBuilderMock.Component()
    let builder = ComponentizedBuilderMock {
      return component
    }
    let _: ComponentizedBuilderMock.Router = builder
      .build(withDynamicBuildDependency: (), dynamicComponentDependency: ())
    
    let assertionFailureException = catchBadInstruction {
      let _: ComponentizedBuilderMock.Router = builder
        .build(withDynamicBuildDependency: (), dynamicComponentDependency: ())
    }
    
    #expect(
      assertionFailureException != nil,
      "Builder should not return the same instance for the same component. Assertion failure is triggered."
    )
  }
  
  @Test
  @MainActor
  func testComponentForCurrentPassBuilderReturnsNewInstanceVerifyNoAssertion() {
    let builder = ComponentizedBuilderMock {
      return ComponentizedBuilderMock.Component()
    }
    let _: ComponentizedBuilderMock.Router = builder
      .build(withDynamicBuildDependency: (), dynamicComponentDependency: ())
    let _: ComponentizedBuilderMock.Router = builder
      .build(withDynamicBuildDependency: (), dynamicComponentDependency: ())
  }
}
