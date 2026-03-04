import Foundation
import ViperArchitecture

protocol RootInteractable: Interactable {}

final class RootInteractor:
  PresentableInteractor<RootPresentable>,
  RootInteractable
{
  
}
