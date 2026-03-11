import Combine
import UIKit

public enum LeakDetectionStatus {
  case inProgress
  case didComplete
}

public struct LeakDefaultExpectationTime {
  public static let deallocation = 1.0
  public static let viewDisappear = 5.0
}

public protocol LeakDetectionHandle {
  func cancel()
}

@MainActor
public class LeakDetector {
  public static private(set) var shared = LeakDetector()
  
  public var status: AnyPublisher<LeakDetectionStatus, Never> {
    return expectationCount
      .map {
        $0 > 0 ? LeakDetectionStatus.inProgress : LeakDetectionStatus.didComplete
      }
      .removeDuplicates()
      .eraseToAnyPublisher()
  }
  
  static func setInstance(_ instance: LeakDetector) {
    self.shared = instance
  }
  
  static var disableLeakDetectorOverride = false
  
  lazy var disableLeakDetector: Bool = {
    if let environmentValue = ProcessInfo().environment["DISABLE_LEAK_DETECTION"] {
      let lowercase = environmentValue.lowercased()
      return lowercase == "yes" || lowercase == "true"
    }
    return LeakDetector.disableLeakDetectorOverride
  }()
  
  private let expectationCount = CurrentValueSubject<Int, Never>(0)
  private let trackingObjects = NSMapTable<AnyObject, AnyObject>.strongToWeakObjects()
  
  @discardableResult
  public func expectDeallocate(
    object: AnyObject,
    inTime time: TimeInterval = LeakDefaultExpectationTime.deallocation
  ) -> LeakDetectionHandle {
    expectationCount.send(expectationCount.value + 1)
    
    let objectDescription = String(describing: object)
    let objectId = String(ObjectIdentifier(object).hashValue) as NSString
    trackingObjects.setObject(object, forKey: objectId)
    
    let handle = LeakDetectionHandleImpl {
      self.expectationCount.send(self.expectationCount.value - 1)
    }
    
    Executor.execute(withDelay: time) {
      if !handle.cancelled {
        let didDeallocate = (self.trackingObjects.object(forKey: objectId) == nil)
        let message = "<\(objectDescription): \(objectId)> has leaked. Objects are expected to be deallocated at this time: \(self.trackingObjects)"
        
        if self.disableLeakDetector {
          if !didDeallocate {
            print("Leak detection is disabled. This should only be used for debugging purposes.")
            print(message)
          }
        } else {
          assert(didDeallocate, message)
        }
      }
      
      self.expectationCount.send(self.expectationCount.value - 1)
    }
    
    return handle
  }
  
  @discardableResult
  public func expectViewControllerDisappear(
    viewController: UIViewController,
    inTime time: TimeInterval = LeakDefaultExpectationTime.viewDisappear
  ) -> LeakDetectionHandle {
    expectationCount.send(expectationCount.value + 1)
    
    let handle = LeakDetectionHandleImpl {
      self.expectationCount.send(self.expectationCount.value - 1)
    }
    
    Executor.execute(withDelay: time) { [weak viewController] in
      if let viewController = viewController, !handle.cancelled {
        let viewDidDisappear = (!viewController.isViewLoaded || viewController.view.window == nil)
        let message = "\(viewController) appearance has leaked. Either its parent router who does not own a view controller was detached, but failed to dismiss the leaked view controller; or the view controller is reused and re-added to window, yet the router is not re-attached but re-created. Objects are expected to be deallocated at this time: \(self.trackingObjects)"
        
        if self.disableLeakDetector {
          if !viewDidDisappear {
            print("Leak detection is disabled. This should only be used for debugging purposes.")
            print(message)
          }
        } else {
          assert(viewDidDisappear, message)
        }
      }
      
      self.expectationCount.send(self.expectationCount.value - 1)
    }
    
    return handle
  }
}

private final class LeakDetectionHandleImpl: LeakDetectionHandle {
  var cancelled: Bool {
    return cancelledRelay.value
  }
  
  let cancelledRelay = CurrentValueSubject<Bool, Never>(false)
  let cancelClosure: (() -> ())?
  
  init(cancelClosure: (() -> ())? = nil) {
    self.cancelClosure = cancelClosure
  }
  
  func cancel() {
    cancelledRelay.send(true)
    cancelClosure?()
  }
}
