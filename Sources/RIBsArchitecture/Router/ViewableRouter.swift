import Combine
import Foundation

open class ViewableRouter<InteractorType, ViewControllerType>:
  Router<InteractorType>,
  ViewableRouting
{
  public let viewController: ViewControllerType
  public let viewControllable: any ViewControllable
  
  private var viewControllerDisappearExpectation: LeakDetectionHandle?
  
  private let leakDetector: LeakDetector
  
  public init(
    interactor: InteractorType,
    viewController: ViewControllerType,
    leakDetector: LeakDetector = .shared
  ) {
    self.viewController = viewController
    guard let viewControllable = viewController as? ViewControllable else {
      fatalError("\(viewController) shoud conform to \(ViewControllable.self)")
    }
    self.viewControllable = viewControllable
    self.leakDetector = leakDetector
    super.init(interactor: interactor, leakDetector: leakDetector)
  }
  
  override func internalDidLoad() {
    setupViewControllerLeakDetection()
    super.internalDidLoad()
  }
  
  @MainActor
  deinit {
    leakDetector.expectDeallocate(
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
          viewControllerDisappearExpectation = leakDetector.expectViewControllerDisappear(viewController: viewControllable.uiViewController)
        }
      }
    deinitCancellable.add(task: cancellable)
  }
}
