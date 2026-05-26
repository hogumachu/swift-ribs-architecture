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
  
  @Test
  @MainActor
  func testBuildWithBothDynamicDependenciesUsesShortOverload() {
    let builder = FullDependencyComponentizedBuilderMock()
    let buildDependency = FullDependencyComponentizedBuilderMock.BuildDependency(value: "build")
    let componentDependency = FullDependencyComponentizedBuilderMock.ComponentDependency(value: "component")
    
    let router = builder.build(with: buildDependency, componentDependency)
    
    #expect(router.buildDependency == buildDependency)
    #expect(router.componentDependency == componentDependency)
  }
  
  @Test
  @MainActor
  func testBuildWithNoDynamicDependenciesUsesShortOverload() {
    let builder = ComponentizedBuilderMock {
      return ComponentizedBuilderMock.Component()
    }
    
    let _: ComponentizedBuilderMock.Router = builder.build()
    
    #expect(builder.buildCallCount == 1)
  }
  
  @Test
  @MainActor
  func testBuildWithDynamicBuildDependencyUsesShortOverload() {
    let builder = BuildDependencyOnlyComponentizedBuilderMock()
    let buildDependency = BuildDependencyOnlyComponentizedBuilderMock.BuildDependency(value: "build")
    
    let router = builder.build(with: buildDependency)
    
    #expect(router.buildDependency == buildDependency)
  }
  
  @Test
  @MainActor
  func testBuildWithDynamicComponentDependencyUsesShortOverload() {
    let builder = ComponentDependencyOnlyComponentizedBuilderMock()
    let componentDependency = ComponentDependencyOnlyComponentizedBuilderMock.ComponentDependency(value: "component")
    
    let router = builder.build(with: componentDependency)
    
    #expect(router.componentDependency == componentDependency)
  }
}
