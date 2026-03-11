import Foundation

open class ViewableRouter<InteractorType, ViewControllerType>:
  Router<InteractorType>,
  ViewableRouting
{
  public let viewController: ViewControllerType
  public let viewControllable: any ViewControllable
  
  private var viewControllerDisappearExpectation: LeakDetectionHandle?
  
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
  
  override func internalDidLoad() {
    setupViewControllerLeakDetection()
    super.internalDidLoad()
  }
  
  @MainActor
  deinit {
    LeakDetector.shared.expectDeallocate(
      object: viewControllable.uiViewController,
      inTime: LeakDefaultExpectationTime.viewDisappear
    )
  }
  
  private func setupViewControllerLeakDetection() {
    let cancellable = interactable
      .isActiveStream
      .sink { [weak self] isActive in
        guard let self else { return }
        viewControllerDisappearExpectation?.cancel()
        viewControllerDisappearExpectation = nil
        
        if !isActive {
          viewControllerDisappearExpectation = LeakDetector
            .shared
            .expectViewControllerDisappear(viewController: viewControllable.uiViewController)
        }
      }
    deinitCancellable.insert(cancellable)
  }
}
