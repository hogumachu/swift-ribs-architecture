import Combine
import Dispatch
import Foundation

@MainActor
public class Executor {
  static var subscriptions: Set<AnyCancellable> = .init()
  
  public static func execute(
    withDelay delay: TimeInterval,
    maxFrameDuration: Int = 33,
    logic: @escaping () -> ()
  ) {
    let period = TimeInterval(maxFrameDuration / 3) / 1_000 // milliseconds
    var lastRunLoopTime = Date().timeIntervalSinceReferenceDate
    var properFrameTime = 0.0
    var didExecute = false
    var cancellable: AnyCancellable?
    
    cancellable = Timer.publish(every: period, on: .main, in: .common)
      .autoconnect()
      .prefix(while: { _ in
        !didExecute
      })
      .sink(receiveCompletion: { [weak cancellable] _ in
        if let cancellable = cancellable {
          subscriptions.remove(cancellable)
        }
      }, receiveValue: { _ in
        let currentTime = Date().timeIntervalSinceReferenceDate
        let trueElapsedTime = currentTime - lastRunLoopTime
        lastRunLoopTime = currentTime
        
        let boundedElapsedTime = min(trueElapsedTime, Double(maxFrameDuration) / 1000)
        properFrameTime += boundedElapsedTime
        if properFrameTime > delay {
          didExecute = true
          
          logic()
        }
      })
    
    cancellable?.store(in: &subscriptions)
  }
}
