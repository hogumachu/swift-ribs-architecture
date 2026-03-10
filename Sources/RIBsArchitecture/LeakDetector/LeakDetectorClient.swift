import Foundation

public struct LeakDetectorClient: Sendable {
  public var expectDeallocate: @Sendable (_ object: AnyObject, _ time: TimeInterval) -> Void
}
