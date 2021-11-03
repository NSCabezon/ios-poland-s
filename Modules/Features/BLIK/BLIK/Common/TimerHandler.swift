import Foundation

final class TimerHandler {
    private var timer: Timer?
    private(set) var counter = 0
    
    var didUpdate: ((Int) -> Void)?
    var didEnd: (() -> Void)?

    func startTimer(duration: TimeInterval) {
        counter = Int(duration)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.counter -= 1
            self.didUpdate?(self.counter)
            
            if self.counter <= 0 {
                self.stopTimer()
                self.didEnd?()
            }
        }
        
        timer?.fire()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
