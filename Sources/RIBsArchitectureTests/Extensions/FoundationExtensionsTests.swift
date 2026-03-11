@testable import RIBsArchitecture

import Foundation
import Testing

struct FoundationExtensionsTests {
  @Test(
    "Remove Array Element By Referecne",
    arguments: [
      3, 4, 10, 100, 10_000
    ]
  )
  func testRemoveElementByReference(count: Int) {
    var objects = (1...count).map { _ in NSObject() }
    var expectCount = count
    
    while let object = objects.randomElement() {
      expectCount -= 1
      objects.removeElementByReference(object)
      #expect(objects.count == expectCount)
    }
  }
}
