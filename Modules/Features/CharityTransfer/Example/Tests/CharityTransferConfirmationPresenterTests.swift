import CoreFoundationLib
import PLCommonOperatives
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import CharityTransfer

final class CharityTransferConfirmationPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: CharityTransferConfirmationPresenterProtocol!
    private var view = CharityTransferConfirmationViewControllerMock()
    private var coordinator: CharityTransferConfirmationCoordinatorMock!

    override func setUp() {
        super.setUp()
        coordinator = CharityTransferConfirmationCoordinatorMock()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: CharityTransferConfirmationPresenterProtocol.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
        coordinator = nil
    }
    
    func test_setViewModel_is_called() throws {
        XCTAssertNil(view.viewModel)
        SUT.viewDidLoad()
        XCTAssertNotNil(view.viewModel)
        
        XCTAssertEqual(view.viewModel?.title, "Darowizna dla Fundacji Santander")
        XCTAssertEqual(view.viewModel?.recipientName, "Fundacja Santander")
        XCTAssertEqual(view.viewModel?.accountName, "Konto Jakie Chcę")
        XCTAssertEqual(view.viewModel?.accountNumber, "26 1090 0088 0000 0001 4223 0553")
        XCTAssertEqual(view.viewModel?.amount, 1)
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

private extension CharityTransferConfirmationPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: PLTransfersRepository.self) { resolver in
            PLTransfersRepositoryMock()
        }
        dependencies.register(for: AuthorizeTransactionUseCaseProtocol.self) { _ in
            AuthorizeTransactionUseCaseStub()
        }
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
            PLTransactionParametersProviderMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: CharityTransferSendMoneyInputMapping.self) { resolver in
            CharityTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
        dependencies.register(for: AcceptCharityTransactionProtocol.self) { resolver in
            AcceptCharityTransactionUseCaseMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: CharityTransferConfirmationPresenterProtocol.self) { [unowned self] resolver in
            let presenter = CharityTransferConfirmationPresenter(dependenciesResolver: resolver,
                                                                 model: CharityTransferModel.stub())
            presenter.view = self.view
            return presenter
        }
        dependencies.register(for: CharityTransferSummaryMapping.self) { _ in
            CharityTransferSummaryMapper()
        }
        dependencies.register(for: UseCaseHandler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8)
        }
        dependencies.register(for: CharityTransferConfirmationCoordinatorProtocol.self) { [unowned self] _ in
            self.coordinator
        }
        dependencies.register(for: PLLoginManagerProtocol.self) { resolver in
            PLLoginManagerMock(dependenciesResolver: resolver)
        }
    }
}
