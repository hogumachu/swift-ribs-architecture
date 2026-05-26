import RIBsArchitecture

final class ComponentizedBuilderMock:
  ComponentizedBuilder<ComponentizedBuilderMock.Component, ComponentizedBuilderMock.Router, Void, Void> {
  final class Component {}
  final class Router {}
  
  var buildCallCount = 0
  var buildComponent: Component?
  var buildResult: Router?
  override func build(
    with component: Component,
    _ dynamicBuildDependency: Void
  ) -> Router {
    buildCallCount += 1
    buildComponent = component
    return { _, _ in
      return buildResult ?? .init()
    }(component, dynamicBuildDependency)
  }
}

final class FullDependencyComponentizedBuilderMock:
  ComponentizedBuilder<FullDependencyComponentizedBuilderMock.Component, FullDependencyComponentizedBuilderMock.Router, FullDependencyComponentizedBuilderMock.BuildDependency, FullDependencyComponentizedBuilderMock.ComponentDependency>
{
  struct BuildDependency: Equatable {
    let value: String
  }
  
  struct ComponentDependency: Equatable {
    let value: String
  }
  
  final class Component {
    let dependency: ComponentDependency
    
    init(dependency: ComponentDependency) {
      self.dependency = dependency
    }
  }
  
  final class Router {
    let componentDependency: ComponentDependency
    let buildDependency: BuildDependency
    
    init(
      componentDependency: ComponentDependency,
      buildDependency: BuildDependency
    ) {
      self.componentDependency = componentDependency
      self.buildDependency = buildDependency
    }
  }
  
  init() {
    super.init { dependency in
      Component(dependency: dependency)
    }
  }
  
  override func build(
    with component: Component,
    _ dynamicBuildDependency: BuildDependency
  ) -> Router {
    return Router(
      componentDependency: component.dependency,
      buildDependency: dynamicBuildDependency
    )
  }
}

final class BuildDependencyOnlyComponentizedBuilderMock:
  ComponentizedBuilder<BuildDependencyOnlyComponentizedBuilderMock.Component, BuildDependencyOnlyComponentizedBuilderMock.Router, BuildDependencyOnlyComponentizedBuilderMock.BuildDependency, Void>
{
  struct BuildDependency: Equatable {
    let value: String
  }
  
  final class Component {}
  
  final class Router {
    let buildDependency: BuildDependency
    
    init(buildDependency: BuildDependency) {
      self.buildDependency = buildDependency
    }
  }
  
  init() {
    super.init { _ in
      Component()
    }
  }
  
  override func build(
    with component: Component,
    _ dynamicBuildDependency: BuildDependency
  ) -> Router {
    return Router(buildDependency: dynamicBuildDependency)
  }
}

final class ComponentDependencyOnlyComponentizedBuilderMock:
  ComponentizedBuilder<ComponentDependencyOnlyComponentizedBuilderMock.Component, ComponentDependencyOnlyComponentizedBuilderMock.Router, Void, ComponentDependencyOnlyComponentizedBuilderMock.ComponentDependency>
{
  struct ComponentDependency: Equatable {
    let value: String
  }
  
  final class Component {
    let dependency: ComponentDependency
    
    init(dependency: ComponentDependency) {
      self.dependency = dependency
    }
  }
  
  final class Router {
    let componentDependency: ComponentDependency
    
    init(componentDependency: ComponentDependency) {
      self.componentDependency = componentDependency
    }
  }
  
  init() {
    super.init { dependency in
      Component(dependency: dependency)
    }
  }
  
  override func build(
    with component: Component,
    _ dynamicBuildDependency: Void
  ) -> Router {
    return Router(componentDependency: component.dependency)
  }
}
