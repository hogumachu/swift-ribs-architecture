import Combine
import Foundation

public protocol AnyCancellableTask {
  func cancel()
}

extension Task: AnyCancellableTask {}
extension AnyCancellable: AnyCancellableTask {}
