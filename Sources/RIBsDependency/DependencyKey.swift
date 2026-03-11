import Foundation

public protocol DependencyKey {
  associatedtype Value: Sendable
  static var defaultValue: Value { get }
}
