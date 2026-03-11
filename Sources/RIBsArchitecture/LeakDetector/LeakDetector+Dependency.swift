import Foundation
import RIBsDependency

struct LeakDetectorGeneratorKey: DependencyKey {
  public static let defaultValue: @MainActor @Sendable () -> LeakDetector = { LeakDetector.shared }
}

public struct DateGeneratorKey: DependencyKey {
  public static let defaultValue: @Sendable () -> Date = { Date() }
}

extension DependencyValues {
  public var leakDetectorGenerator: @MainActor @Sendable () -> LeakDetector {
    get { self[LeakDetectorGeneratorKey.self] }
    set { self[LeakDetectorGeneratorKey.self] = newValue }
  }
}
