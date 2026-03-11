import Foundation
import RIBsArchitecture
import RIBsDependency

func withDependencies<T>(
  _ configure: (inout DependencyValues) -> Void,
  operation: () async throws -> T
) async rethrows -> T {
  var deps = DependencyValues.current
  configure(&deps)
  return try await DependencyValues.$current
    .withValue(deps, operation: operation)
}

func withLeakDetector<T>(
  _ leakDetector: LeakDetector,
  operation: @MainActor () async throws -> T
) async rethrows -> T {
  return try await withDependencies {
    $0.leakDetectorGenerator = { leakDetector }
  } operation: { @MainActor in
    try await operation()
  }
}

func withLeakDetectorMock<T>(
  operation: @MainActor (LeakDetectorMock) async throws -> T
) async rethrows -> T {
  let leakDetector = await LeakDetectorMock()
  return try await withDependencies {
    $0.leakDetectorGenerator = { leakDetector }
  } operation: { @MainActor in
    try await operation(leakDetector)
  }
}
