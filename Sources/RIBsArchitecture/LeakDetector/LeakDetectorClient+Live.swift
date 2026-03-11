import RIBsDependency
import UIKit

struct LeakDetectorClientKey: DependencyKey {
  public static let defaultValue = LeakDetectorClient(
    expectDeallocate: { object, time in
      let description = String(describing: object)
      let id = String(ObjectIdentifier(object).hashValue)
      let weakObject = WeakObject(object)
      return Task {
        await LeakStorage.shared.expectDeallocate(
          object: weakObject,
          objectID: id,
          objectDescription: description,
          inTime: time
        )
      }
    },
    expectViewControllerDisappear: { viewController, time in
      let weakObject = WeakObject(viewController)
      return Task {
        await LeakStorage.shared.expectViewControllerDisappear(object: weakObject, inTime: time)
      }
    }
  )
}

public struct LeakDefaultExpectationTime {
  public static let deallocation = 1.0
  public static let viewDisappear = 5.0
}

final class WeakObject: @unchecked Sendable {
  weak var object: AnyObject?
  
  init(_ object: AnyObject?) {
    self.object = object
  }
}

@globalActor
final actor LeakStorage {
  static let shared = LeakStorage()
  
  private var trackingObjects: [String: WeakObject] = [:]
  
  func expectDeallocate(
    object: WeakObject,
    objectID: String,
    objectDescription: String,
    inTime time: TimeInterval
  ) async {
    trackingObjects[objectID] = object
    
    try? await Task.sleep(for: .seconds(time))
    
    if Task.isCancelled {
      return
    }
    let didDeallocate = trackingObjects[objectID]?.object == nil
    let message = "<\(objectDescription): \(objectID)> has leaked. Objects are expected to be deallocated at this time: \(trackingObjects)"
    assert(didDeallocate, message)
    trackingObjects.removeValue(forKey: objectID)
  }
  
  func expectViewControllerDisappear(
    object: WeakObject,
    inTime time: TimeInterval = LeakDefaultExpectationTime.viewDisappear
  )  async {
    try? await Task.sleep(for: .seconds(time))
    guard
      !Task.isCancelled,
      let viewController = object.object as? UIViewController
    else {
      return
    }
    let isViewLoaded = await viewController.isViewLoaded
    let isWindowNull = await viewController.view.window == nil
    let viewDidDisappear = (!isViewLoaded || isWindowNull)
    let message = "\(viewController) appearance has leaked. Either its parent router who does not own a view controller was detached, but failed to dismiss the leaked view controller; or the view controller is reused and re-added to window, yet the router is not re-attached but re-created. Objects are expected to be deallocated at this time: \(trackingObjects)"
    assert(viewDidDisappear, message)
  }
}

extension DependencyValues {
  public var leakDetectorClient: LeakDetectorClient {
    get { self[LeakDetectorClientKey.self] }
    set { self[LeakDetectorClientKey.self] = newValue }
  }
}
