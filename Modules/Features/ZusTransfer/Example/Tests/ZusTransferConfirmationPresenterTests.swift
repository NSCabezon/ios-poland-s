import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import ZusTransfer

class ZusTransferConfirmationPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: ZusTransferConfirmationPresenterProtocol!
    private var view = ZusTransferConfirmationViewControllerMock()
    private var coordinator: ZusTransferConfirmationCoordinatorMock?

    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: ZusTransferConfirmationPresenterProtocol.self)
        coordinator = dependencies.resolve(for: ZusTransferConfirmationCoordinatorProtocol.self) as? ZusTransferConfirmationCoordinatorMock
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
    }
    
    func test_setViewModel_is_called() throws {
        XCTAssertNil(view.viewModel)
        SUT.viewDidLoad()
        XCTAssertNotNil(view.viewModel)
        
        XCTAssertEqual(view.viewModel?.title, "ZUS transfer")
        XCTAssertEqual(view.viewModel?.recipientName, "ZUS")
        XCTAssertEqual(view.viewModel?.accountName, "Konto Jakie Chcę")
        XCTAssertEqual(view.viewModel?.accountNumber, "26 1090 0088 0000 0001 4223 0553")
        XCTAssertEqual(view.viewModel?.amount, 1500)
        XCTAssertFalse(view.viewModel?.items.isEmpty == true)
    }
    
    func test_confirm_called_use_case_success_should_start_showSummary_and_loader_hide() throws {
        SUT.confirmTapped()
        XCTAssertTrue(view.showLoaderCalled)
        TestHelper.delay {
            XCTAssertTrue(self.view.hideLoaderCalled)
            XCTAssertTrue(self.coordinator?.showSummaryCalled == true)
        }
    }
    
    func test_goBack_called_should_start_pop_coordinator_function() throws {
        SUT.goBack()
        TestHelper.delay {
            XCTAssertTrue(self.coordinator?.popCalled == true)
        }
    }
    
    func test_goToTransfer_called_should_start_backToTransfer_coordinator_function() throws {
        SUT.backToTransfer()
        TestHelper.delay {
            XCTAssertTrue(self.coordinator?.backToTransferCalled == true)
        }
    }
}

private extension ZusTransferConfirmationPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: ZusTransferSendMoneyInputMapper.self) { resolver in
            ZusTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
        dependencies.register(for: ZusTransferConfirmationPresenterProtocol.self) { [unowned self] resolver in
            let presenter = ZusTransferConfirmationPresenter(dependenciesResolver: resolver,
                                                             model: ZusTransferModelMockBuilder.getZusTransferModelMock())
            presenter.view = self.view
            return presenter
        }
        dependencies.register(for: ZusTransferSummaryMapping.self) { _ in
            ZusTransferSummaryMapper()
        }
        dependencies.register(for: UseCaseHandler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8)
        }
        dependencies.register(for: ZusTransferConfirmationCoordinatorProtocol.self) { _ in
            ZusTransferConfirmationCoordinatorMock()
        }
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: AcceptZusTransactionProtocol.self) { resolver in
            AcceptZusTransactionUseCase(dependenciesResolver: resolver)
        }
        dependencies.register(for: ZusTransferSendMoneyInputMapping.self) { resolver in
            ZusTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
            PLTransactionParametersProviderMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLLoginManagerProtocol.self) { resolver in
            PLLoginManagerMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLTransfersManagerProtocol.self) { resolver in
            PLTransfersManagerSuccessMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: ZusPrepareChallengeUseCaseProtocol.self) { resolver in
            ZusPrepareChallengeUseCase(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLTransfersRepository.self) { resolver in
            PLTransfersRepositoryMock()
        }
    }
}
