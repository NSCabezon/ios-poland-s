import Foundation

struct TestHelper {
    static func delay(seconds: DispatchTime = .now() + 0.1, finished: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: seconds) {
            finished?()
        }
    }
}
