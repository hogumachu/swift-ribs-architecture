import Foundation
import RIBsDependency

struct LeakDetectorClientKey: DependencyKey {
  public static let defaultValue = LeakDetectorClient(
    expectDeallocate: { object, time in
      let description = String(describing: object)
      let id = String(ObjectIdentifier(object).hashValue)
      let weakObject = WeakObject(object)
      Task {
        await LeakStorage.shared.expectDeallocate(
          object: weakObject,
          objectID: id,
          objectDescription: description,
          inTime: time
        )
      }
    }
  )
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
}

extension DependencyValues {
  public var leakDetectorClient: LeakDetectorClient {
    get { self[LeakDetectorClientKey.self] }
    set { self[LeakDetectorClientKey.self] = newValue }
  }
}
