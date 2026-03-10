import Foundation

public struct DependencyValues: Sendable {
  @TaskLocal public static var current = DependencyValues()
  
  private var storage: [ObjectIdentifier: any Sendable] = [:]
  
  public subscript<Key: DependencyKey>(key: Key.Type) -> Key.Value {
    get {
      guard let value = storage[ObjectIdentifier(key)] as? Key.Value else {
        return Key.defaultValue
      }
      return value
    }
    set {
      storage[ObjectIdentifier(key)] = newValue
    }
  }
}
