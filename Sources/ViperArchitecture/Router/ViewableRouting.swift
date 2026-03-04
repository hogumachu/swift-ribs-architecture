import Foundation

public protocol ViewableRouting: Routing {
  var viewControllable: any ViewControllable { get }
}
