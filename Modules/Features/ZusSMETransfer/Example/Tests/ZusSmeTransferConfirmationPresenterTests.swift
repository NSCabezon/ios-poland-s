import CoreFoundationLib
import PLCommonOperatives
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import ZusSMETransfer

final class ZusSmeTransferConfirmationPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: ZusSmeTransferConfirmationPresenterProtocol!
    private var view = ZusSmeTransferConfirmationViewControllerMock()
    private var coordinator = ZusSmeTransferConfirmationCoordinatorMock()
    private var authorizeMockUseCase: AuthorizeTransactionUseCaseMock?
    private var acceptZusTransactionUseCaseMock: AcceptZusSmeTransactionUseCaseMock?
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: ZusSmeTransferConfirmationPresenterProtocol.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
        authorizeMockUseCase = nil
        acceptZusTransactionUseCaseMock = nil
    }
    
    func test_setViewModel_is_called() throws {
        XCTAssertNil(view.viewModel)
        SUT.viewDidLoad()
        XCTAssertNotNil(view.viewModel)
        XCTAssertEqual(view.viewModel?.title, "ZUS transfer")
        XCTAssertEqual(view.viewModel?.recipientName, "ZUS")
        XCTAssertEqual(view.viewModel?.accountName, "Konto Jakie Chcę")
        XCTAssertEqual(view.viewModel?.amount, 1500)
        XCTAssertFalse(view.viewModel?.items.isEmpty == true)
    }
    
    func test_confirm_called_use_case_success_should_start_showSummary_and_loader_hide() throws {
        SUT.confirmTapped()
        XCTAssertTrue(view.showLoaderCalled)
        delayedTests { [unowned self] in
            XCTAssertTrue(self.view.hideLoaderCalled)
            XCTAssertTrue(self.coordinator.showSummaryCalled)
        }
    }
    
    func test_goBack_called_should_start_pop_coordinator_function() throws {
        SUT.goBack()
        XCTAssertTrue(coordinator.popCalled)
    }
    
    func test_goToTransfer_called_should_start_backToTransfer_coordinator_function() throws {
        SUT.backToTransfer()
        XCTAssertTrue(coordinator.backToTransferCalled)
    }
}

private extension ZusSmeTransferConfirmationPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: ZusSmeTransferConfirmationCoordinatorProtocol.self) { [unowned self] _ in
            self.coordinator
        }
        dependencies.register(for: ZusSmeTransferSendMoneyInputMapping.self) { resolver in
            ZusSmeTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
        dependencies.register(for: ZusSmeTransferConfirmationPresenterProtocol.self) { [unowned self] resolver in
            let presenter = ZusSmeTransferConfirmationPresenter(
                dependenciesResolver: resolver,
                model: ZusSmeTransferModel.stub()
            )
            presenter.view = self.view
            return presenter
        }
        dependencies.register(for: ZusSmeTransferSummaryMapping.self) { _ in
            ZusSmeTransferSummaryMapper()
        }
        dependencies.register(for: UseCaseHandler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8)
        }
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: AcceptZusSmeTransactionProtocol.self) { _ in
            AcceptZusSmeTransactionUseCaseMock()
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
        dependencies.register(for: PLTransfersRepository.self) { resolver in
            PLTransfersRepositoryMock()
        }
        dependencies.register(for: AuthorizeTransactionUseCaseProtocol.self) { _ in
            AuthorizeTransactionUseCaseMock()
        }
        dependencies.register(for: ChallengesHandlerDelegate.self) { resolver in
            PLAuthorizationCoordinatorMock()
        }
    }
}
