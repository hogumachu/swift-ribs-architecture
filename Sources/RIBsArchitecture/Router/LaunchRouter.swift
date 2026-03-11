import UIKit

open class LaunchRouter<InteractorType, ViewControllerType>:
  ViewableRouter<InteractorType, ViewControllerType>,
  LaunchRouting
{
  public override init(
    interactor: InteractorType,
    viewController: ViewControllerType,
    leakDetector: LeakDetector = .shared
  ) {
    super.init(
      interactor: interactor,
      viewController: viewController,
      leakDetector: leakDetector
    )
  }
  
  public final func launch(from window: UIWindow) {
    window.rootViewController = viewControllable.uiViewController
    window.makeKeyAndVisible()
    interactable.activate()
    load()
  }
}
