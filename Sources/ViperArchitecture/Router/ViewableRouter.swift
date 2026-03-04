import Foundation

open class ViewableRouter<InteractorType, ViewControllerType>:
  Router<InteractorType>,
  ViewableRouting
{
  public let viewController: ViewControllerType
  public let viewControllable: any ViewControllable
  
  public init(
    interactor: InteractorType,
    viewController: ViewControllerType
  ) {
    self.viewController = viewController
    guard let viewControllable = viewController as? ViewControllable else {
      fatalError("\(viewController) shoud conform to \(ViewControllable.self)")
    }
    self.viewControllable = viewControllable
    super.init(interactor: interactor)
  }
}
