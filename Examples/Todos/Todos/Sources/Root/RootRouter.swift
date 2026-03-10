import Foundation
import RIBsArchitecture

protocol RootViewControllable: ViewControllable {}

protocol RootRouting: ViewableRouting {}

final class RootRouter:
  LaunchRouter<RootInteractable, RootViewControllable>,
  RootRouting
{
  
}
