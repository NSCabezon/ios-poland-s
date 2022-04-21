import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import ZusTransfer

class AcceptZusTransactionUseCaseTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: AcceptZusTransactionProtocol!
    private var useCaseHandler: UseCaseHandler!
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: AcceptZusTransactionProtocol.self)
        useCaseHandler = dependencies.resolve(for: UseCaseHandler.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
        useCaseHandler = nil
    }
    
    func test_sendConfirmation_transaction_use_case_success() throws {
        setUpPLTransfersManagerSuccessMock()
        let scenario = Scenario(useCase: SUT,
                                input: .init(model: ZusTransferModelMockBuilder.getZusTransferModelMock()))
            .execute(on: useCaseHandler)

        scenario.onSuccess { result in
            XCTAssertEqual(result.summary.amount, 1500)
            XCTAssertEqual(result.summary.currency, .złoty)
            XCTAssertEqual(result.summary.transferType, .ZUS)
            XCTAssertEqual(result.summary.accountName, "GABRIELA RYBA UL. JASNOGÓRSKA 70A/13 01-496 CZĘSTOCHOWA")
            XCTAssertEqual(result.summary.accountNumber, "26 1090 0088 0000 0001 4223 0553")
        }

        scenario.onError { _ in
            XCTFail()
        }
    }
    
    func test_sendConfirmation_transaction_use_case_nonConnection_failure() throws {
        setUpPLTransfersManagerNonConnectionFailureMock()
        let scenario = Scenario(useCase: SUT,
                                input: .init(model: ZusTransferModelMockBuilder.getZusTransferModelMock()))
            .execute(on: useCaseHandler)
        scenario.onError { error in
            XCTAssertEqual(error.getErrorDesc(),
                           AcceptZusTransactionErrorResult.noConnection.rawValue)
        }
    }
}

private extension AcceptZusTransactionUseCaseTests {
    func setUpDependencies() {
        dependencies.register(for: ZusTransferSendMoneyInputMapping.self) { resolver in
            ZusTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
        dependencies.register(for: AcceptZusTransactionProtocol.self) { resolver in
            AcceptZusTransactionUseCase(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLLoginManagerProtocol.self) { resolver in
            PLLoginManagerMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
            PLTransactionParametersProviderMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: ZusTransferSummaryMapping.self) { _ in
            ZusTransferSummaryMapper()
        }
        dependencies.register(for: UseCaseHandler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8)
        }
    }
    
    func setUpPLTransfersManagerSuccessMock() {
        dependencies.register(for: PLTransfersManagerProtocol.self) { resolver in
            PLTransfersManagerSuccessMock(dependenciesResolver: resolver)
        }
    }
    
    func setUpPLTransfersManagerNonConnectionFailureMock() {
        dependencies.register(for: PLTransfersManagerProtocol.self) { resolver in
            PLTransfersManagerNonConnectionFailureMock(dependenciesResolver: resolver)
        }
    }
}
