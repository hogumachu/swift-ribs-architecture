import Foundation
import RIBsArchitecture

protocol RootInteractable: Interactable {}

final class RootInteractor:
  PresentableInteractor<RootPresentable>,
  RootInteractable
{
  
}
