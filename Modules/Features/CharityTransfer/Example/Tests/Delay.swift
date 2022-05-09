import Foundation
import XCTest

extension XCTestCase {
    func delayedTests(_ delayInterval: TimeInterval = 0.1, tests: @escaping () -> Void) {
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInterval) {
            tests()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: delayInterval + 1)
    }
}
