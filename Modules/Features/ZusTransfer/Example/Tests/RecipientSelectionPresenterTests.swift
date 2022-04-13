import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import ZusTransfer

final class RecipientSelectionPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: RecipientSelectionPresenterProtocol?
    private var view: RecipientSelectionViewControllerMock?
    private var mockUseCase: GetRecipientsUseCaseMock?
    private var coordinator: RecipientSelectionViewCoordinatorMock?
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: RecipientSelectionPresenterProtocol.self)
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
        view = nil
        mockUseCase = nil
        coordinator = nil
    }
    
    func test_setViewModels_is_called() throws {
        let view = try XCTUnwrap(view)
        let SUT = try XCTUnwrap(SUT)
        let mockUseCase = try XCTUnwrap(mockUseCase)
        let output = GetRecipientsUseCaseOutput(
            recipients: [
                RecipientsBuilderMock.getRecipientMock()
            ]
        )
        mockUseCase.result = .ok(output)
        XCTAssertFalse(view.setViewModelCalled)
        SUT.viewDidLoad()
        delayedTests {
            XCTAssertTrue(view.setViewModelCalled)
        }
    }
    
    func test_viewDidLoad_should_show_loader_and_hide_loader_after_download_data() throws {
        let view = try XCTUnwrap(view)
        let SUT = try XCTUnwrap(SUT)
        let mockUseCase = try XCTUnwrap(mockUseCase)
        let output = GetRecipientsUseCaseOutput(
            recipients: [
                RecipientsBuilderMock.getRecipientMock()
            ]
        )
        mockUseCase.result = .ok(output)
        SUT.viewDidLoad()
        XCTAssertTrue(view.showLoaderCalled)
        delayedTests {
            XCTAssertTrue(view.hideLoaderCalled)
        }
    }
    
    
    func test_didSelectBack_called_should_start_backCalled_coordinator_function() throws {
        let SUT = try XCTUnwrap(SUT)
        let coordinator = try XCTUnwrap(coordinator)
        SUT.didSelectBack()
        XCTAssertTrue(coordinator.backCalled)
    }
    
    func test_didSelectCloseProcess_called_should_start_didSelectCloseProcess_coordinator_function() throws {
        let SUT = try XCTUnwrap(SUT)
        let coordinator = try XCTUnwrap(coordinator)
        SUT.didSelectCloseProcess()
        XCTAssertTrue(coordinator.closeProcessCalled)
    }
    
    func test_didSelectCell_called_should_start_didSelectRecipient_coordinator_function() throws {
        let SUT = try XCTUnwrap(SUT)
        let coordinator = try XCTUnwrap(coordinator)
        let view = try XCTUnwrap(view)
        let mockUseCase = try XCTUnwrap(mockUseCase)
        let output = GetRecipientsUseCaseOutput(
            recipients: [
                RecipientsBuilderMock.getRecipientMock()
            ]
        )
        mockUseCase.result = .ok(output)
        SUT.viewDidLoad()
        view.onConfirmSetViewModel = { [unowned self] in
            SUT.didSelectCell(at: 0)
            self.delayedTests {
                XCTAssertTrue(coordinator.didSelectRecipientCalled)
            }
        }
    }
    
    func test_nonConnection_should_show_error_dialog() throws {
        setUpPLTransfersManagerNonConnectionFailureMock()
        let view = try XCTUnwrap(view)
        let SUT = try XCTUnwrap(SUT)
        SUT.viewDidLoad()
        XCTAssertTrue(view.showLoaderCalled)
        delayedTests {
            XCTAssertTrue(view.hideLoaderCalled)
            XCTAssertTrue(view.showErrorMessageCalled)
        }
    }
}

private extension RecipientSelectionPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: RecipientSelectionCoordinatorProtocol.self) { [unowned self] _ in
            let coordinatorMock = RecipientSelectionViewCoordinatorMock()
            self.coordinator = coordinatorMock
            return coordinatorMock
        }
        dependencies.register(for: RecipientMapping.self) { _ in
            RecipientMapper()
        }
        dependencies.register(for: GetRecipientsUseCaseProtocol.self) { [unowned self] _ in
            let useCase = GetRecipientsUseCaseMock()
            self.mockUseCase = useCase
            return useCase
        }
        dependencies.register(for: UseCaseScheduler.self) { _ in
            DispatchQueue.main
        }
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: PLTransfersManagerProtocol.self) { resolver in
            PLTransfersManagerSuccessMock(dependenciesResolver: resolver)
        }
        dependencies.register(for: RecipientSelectionPresenterProtocol.self) { [unowned self] resolver in
            let presenter = RecipientSelectionPresenter(
                dependenciesResolver: resolver,
                maskAccount: MaskAccountMock.mask
            )
            self.view = RecipientSelectionViewControllerMock()
            presenter.view = self.view
            return presenter
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
