import Commons
@testable import BLIK
import DomainCommon
import SANPLLibrary
import XCTest

class P2pAliasUseCaseTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var queue: DispatchQueue!
    private var SUT: P2pAliasUseCase!
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        queue = DispatchQueue(label: "P2pAliasUseCaseTests")
        SUT = dependencies.resolve(for: P2pAliasUseCase.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        queue = nil
        SUT = nil
    }
    
    func test_p2p_alias_use_case_success() throws {
        setUpBLIKManagerSuccessMock()
        let scenario = Scenario(useCase: SUT, input: .init(msisdn: "123 456 789"))
            .execute(on: queue)
        
        queue.sync {}
        
        scenario.onSuccess { p2pAlias in
            XCTAssertEqual(p2pAlias.dstAccNo, "12 3456 7890 1234 5678 9012 3456")
            XCTAssertEqual(p2pAlias.isDstAccInternal, true)
        }
        
        scenario.onError { _ in
            XCTFail()
        }
    }
    
    func test_p2p_alias_use_case_fail() throws {
        setUpBLIKManagerFailureMock()
        let scenario = Scenario(useCase: SUT, input: .init(msisdn: "123 456 789"))
            .execute(on: queue)
        
        queue.sync {}
        
        scenario.onSuccess { _ in
            XCTFail()
        }
        
        scenario.onError { _ in
            XCTAssert(true)
        }
    }
}

private extension P2pAliasUseCaseTests {
    
    func setUpDependencies() {
        dependencies.register(for: P2pAliasUseCase.self) { resolver in
            P2pAliasUseCase(dependenciesResolver: resolver)
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
