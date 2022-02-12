import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import XCTest
@testable import ZusTransfer

final class ZusTransferSummaryPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: ZusTransferSummaryPresenterProtocol!
    private var view: ZusTransferSummaryViewControllerMock!
    private var coordinator: ZusTransferSummaryCoordinatorMock?
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: ZusTransferSummaryPresenterProtocol.self)
        coordinator = dependencies.resolve(for: ZusTransferSummaryCoordinatorProtocol.self) as? ZusTransferSummaryCoordinatorMock
    }
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        SUT = nil
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
    
    func test_generic_button_anotherPayment_called_should_start_goToMakeAnotherPayment_coordinator_function() throws {
        SUT.viewDidLoad()
        let viewModel = view.operativeSummaryStandardFooterItemViewModels?.first {
            $0.title == "generic_button_anotherPayment"
        }
        XCTAssertNotNil(viewModel)
        viewModel?.action()
        TestHelper.delay {
            XCTAssertTrue(self.coordinator?.goToMakeAnotherPaymentCalled == true)
        }
    }
    
    func test_generic_button_globalPosition_called_should_start_goToGlobalPosition_coordinator_function() throws {
        SUT.viewDidLoad()
        let viewModel = view.operativeSummaryStandardFooterItemViewModels?.first {
            $0.title == "generic_button_globalPosition"
        }
        XCTAssertNotNil(viewModel)
        viewModel?.action()
        TestHelper.delay {
            XCTAssertTrue(self.coordinator?.goToGlobalPositionCalled == true)
        }
    }
    
    func test_goToCharityTransfer_called_should_start_goToMakeAnotherPayment_coordinator_function() throws {
        SUT.goToZusTransfer()
        TestHelper.delay {
            XCTAssertTrue(self.coordinator?.goToMakeAnotherPaymentCalled == true)
        }
    }
}

private extension ZusTransferSummaryPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: ZusTransferSummaryCoordinatorProtocol.self) { _ in
            ZusTransferSummaryCoordinatorMock()
        }
        dependencies.register(for: ZusTransferSummaryMapping.self) { _ in
            ZusTransferSummaryMapper()
        }
        dependencies.register(for: UseCaseHandler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8)
        }
        dependencies.register(for: ZusTransferSummaryPresenterProtocol.self) { [unowned self] resolver in
            let presenter = ZusTransferSummaryPresenter(
                dependenciesResolver: resolver,
                summary: ZusTransferSummaryMockBuilder.getZusTransferSummaryMock()
            )
            self.view = ZusTransferSummaryViewControllerMock(presenter: presenter)
            presenter.view = self.view
            return presenter
        }
    }
}
