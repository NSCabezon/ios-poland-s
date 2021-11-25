import Commons
@testable import BLIK
import CoreFoundationLib
import SANPLLibrary
import XCTest

class PhoneVerificationUseCaseTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var queue: DispatchQueue!
    private var SUT: PhoneVerificationUseCase!

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        queue = DispatchQueue(label: "PhoneVerificationUseCaseTests")
        SUT = dependencies.resolve(for: PhoneVerificationUseCase.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        queue = nil
        SUT = nil
    }

    func test_verify_phone_number_use_case_success() throws {
        let scenario = Scenario(useCase: SUT, input: .init(phoneNumbers: ["00123 456 789", "987 654 321", "0"]))
            .execute(on: queue)
            
        queue.sync { }
        
        scenario.onSuccess { hashedNumbers in
            let hashedNumbersMetadata = hashedNumbers.phoneNumbers
            XCTAssertEqual(hashedNumbersMetadata.count, 2)
            XCTAssertEqual(hashedNumbersMetadata[0].hash, "48123456789".sha256())
            XCTAssertEqual(hashedNumbersMetadata[0].unformattedNumber, "00123 456 789")
            XCTAssertEqual(hashedNumbersMetadata[1].hash, "48987654321".sha256())
            XCTAssertEqual(hashedNumbersMetadata[1].unformattedNumber, "987 654 321")
        }
        
        scenario.onError { _ in
            XCTFail()
        }
    }
}

private extension PhoneVerificationUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: PhoneVerificationUseCase.self) { resolver in
            PhoneVerificationUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PLBLIKManagerProtocol.self) { resolver in
            MockBLIKManager()
        }
    }

}
