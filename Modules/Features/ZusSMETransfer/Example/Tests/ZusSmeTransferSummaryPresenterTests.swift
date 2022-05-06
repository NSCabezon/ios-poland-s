import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import ZusSMETransfer

final class ZusSmeTransferSummaryPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: ZusSmeTransferSummaryPresenterProtocol!
    private var view: ZusSmeTransferSummaryViewControllerMock!
    private var coordinator: ZusSmeTransferSummaryCoordinatorMock?
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: ZusSmeTransferSummaryPresenterProtocol.self)
        coordinator = dependencies.resolve(for: ZusSmeTransferSummaryCoordinatorProtocol.self) as? ZusSmeTransferSummaryCoordinatorMock
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
        view = nil
        coordinator = nil
    }
    
    func test_setViewModels_is_called() throws {
        XCTAssertFalse(view.buildCalled)
        XCTAssertFalse(view.setupStandardBodyCalled)
        XCTAssertFalse(view.setupStandardFooterWithTitleCalled)
        XCTAssertFalse(view.setupStandardHeaderCalled)
        SUT.viewDidLoad()
        XCTAssertTrue(view.buildCalled)
        XCTAssertTrue(view.setupStandardBodyCalled)
        XCTAssertTrue(view.setupStandardFooterWithTitleCalled)
        XCTAssertTrue(view.setupStandardHeaderCalled)
    }
    
    func test_setViewModels() throws {
        XCTAssertNil(view.operativeSummaryStandardFooterItemViewModels)
        XCTAssertNil(view.operativeSummaryStandardHeaderViewModel)
        XCTAssertNil(view.operativeSummaryStandardBodyActionViewModels)
        XCTAssertNil(view.operativeSummaryStandardBodyItemViewModels)
        SUT.viewDidLoad()
        XCTAssertNotNil(view.operativeSummaryStandardFooterItemViewModels)
        XCTAssertNotNil(view.operativeSummaryStandardHeaderViewModel)
        XCTAssertNotNil(view.operativeSummaryStandardBodyActionViewModels)
        XCTAssertNotNil(view.operativeSummaryStandardBodyItemViewModels)
        XCTAssertTrue(view.operativeSummaryStandardFooterItemViewModels?.count == 3)
        XCTAssertTrue(view.operativeSummaryStandardBodyItemViewModels?.count == 5)
    }
    
    func test_generic_button_globalPosition_called_should_start_goToGlobalPosition_coordinator_function() throws {
        SUT.viewDidLoad()
        let viewModel = view.operativeSummaryStandardFooterItemViewModels?.first {
            $0.title == "generic_button_globalPosition"
        }
        XCTAssertNotNil(viewModel)
        viewModel?.action()
        XCTAssertTrue(coordinator?.goToGlobalPositionCalled == true)
    }
    
    func test_goToZusTransfer_called_should_start_goToMakeAnotherPayment_coordinator_function() throws {
        SUT.viewDidLoad()
        let viewModel = view.operativeSummaryStandardFooterItemViewModels?.first {
            $0.title == "generic_button_anotherPayment"
        }
        XCTAssertNotNil(viewModel)
        viewModel?.action()
        XCTAssertTrue(coordinator?.goToMakeAnotherPaymentCalled == true)
    }
}

private extension ZusSmeTransferSummaryPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: ZusSmeTransferSummaryCoordinatorProtocol.self) { [unowned self] _ in
            let mock = ZusSmeTransferSummaryCoordinatorMock()
            self.coordinator = mock
            return mock
        }
        dependencies.register(for: ZusSmeTransferSummaryMapping.self) { _ in
            ZusSmeTransferSummaryMapper()
        }
        dependencies.register(for: UseCaseHandler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8)
        }
        dependencies.register(for: ZusSmeTransferSummaryPresenterProtocol.self) { [unowned self] resolver in
            let presenter = ZusSmeTransferSummaryPresenter(
                dependenciesResolver: resolver,
                summary: ZusSmeTransferSummaryStubBuilder.getZusSmeTransferSummaryStub()
            )
            self.view = ZusSmeTransferSummaryViewControllerMock(presenter: presenter)
            presenter.view = self.view
            return presenter
        }
    }
}
