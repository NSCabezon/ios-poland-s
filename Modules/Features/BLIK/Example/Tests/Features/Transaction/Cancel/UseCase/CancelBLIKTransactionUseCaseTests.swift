import Commons
@testable import BLIK
import DomainCommon
import SANPLLibrary
import XCTest

class CancelBLIKTransactionUseCaseTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var queue: DispatchQueue!
    private var SUT: CancelBLIKTransactionUseCase!

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        queue = DispatchQueue(label: "CancelBLIKTransactionUseCaseTests")
        SUT = dependencies.resolve(for: CancelBLIKTransactionUseCase.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        queue = nil
        SUT = nil
    }

    func test_cancel_transaction_use_case_success() throws {
        setUpBLIKManagerSuccessMock()
        
        let scenario = Scenario(useCase: SUT,
                                input: .init(trnId: 1, trnDate: "2021-07-27", cancelType: .exit))
            .execute(on: queue)
            
        queue.sync { }
        
        scenario.onSuccess {
            XCTAssert(true)
        }
        
        scenario.onError { _ in
            XCTFail()
        }
    }

    func test_cancel_transaction_use_case_failure() throws {
        setUpBLIKManagerFailureMock()
        
        let scenario = Scenario(useCase: SUT,
                                input: .init(trnId: 1, trnDate: "2021-07-27", cancelType: .exit))
            .execute(on: queue)

        queue.sync { }
        
        scenario.onSuccess {
            XCTFail()
        }
        
        scenario.onError { _ in
            XCTAssert(true)
        }
        
    }
}

private extension CancelBLIKTransactionUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: CancelBLIKTransactionUseCase.self) { resolver in
            CancelBLIKTransactionUseCase(dependenciesResolver: resolver)
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
