import Commons
@testable import BLIK
import CoreFoundationLib
import SANPLLibrary
import XCTest

class GetTrnToConfUseCaseTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var queue: DispatchQueue!
    private var SUT: GetTrnToConfUseCase!

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        queue = DispatchQueue(label: "GetTrnToConfUseCaseTests")
        SUT = dependencies.resolve(for: GetTrnToConfUseCase.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        queue = nil
        SUT = nil
    }

    func test_cancel_transaction_use_case_success() throws {
        setUpBLIKManagerSuccessMock()
        
        let scenario = Scenario(useCase: SUT)
            .execute(on: queue)
            
        queue.sync { }
        
        scenario.onSuccess { result in
            let trnDto = result.transaction
            XCTAssertEqual(trnDto.title, "Przelew")
            XCTAssertEqual(trnDto.date, "2021-06-28")
            XCTAssertEqual(trnDto.transferType, .blikWebPurchases)
            XCTAssertEqual(trnDto.amount.amount, 14.99)
            XCTAssertEqual(trnDto.merchant?.city, "Kraków")
        }
        
        scenario.onError { _ in
            XCTFail()
        }
    }

    func test_cancel_transaction_use_case_failure() throws {
        setUpBLIKManagerFailureMock()
        
        let scenario = Scenario(useCase: SUT)
            .execute(on: queue)

        queue.sync { }
        
        scenario.onSuccess { _ in
            XCTFail()
        }
        
        scenario.onError { _ in
            XCTAssert(true)
        }
        
    }
}

private extension GetTrnToConfUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: GetTrnToConfUseCase.self) { resolver in
            GetTrnToConfUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
    }
    
    func setUpBLIKManagerSuccessMock() {
        dependencies.register(for: PLBLIKManagerProtocol.self) { resolver in
            MockBLIKManager()
        }
    }

    func setUpBLIKManagerFailureMock() {
        dependencies.register(for: PLBLIKManagerProtocol.self) { resolver in
            MockBLIKManager(forceError: true)
        }
    }

}
