import Foundation
import RIBsDependency

public func withDependencies<T>(
  _ configure: (inout DependencyValues) -> Void,
  operation: () async throws -> T
) async rethrows -> T {
  var deps = DependencyValues.current
  configure(&deps)
  return try await DependencyValues.$current
    .withValue(deps, operation: operation)
}
