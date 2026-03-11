import Foundation

package extension Array {
  mutating func removeElementByReference(_ element: Element) {
    guard let index = firstIndex(where: { $0 as AnyObject === element as AnyObject }) else {
      return
    }
    remove(at: index)
  }
}
