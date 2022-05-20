import Foundation
import CoreFoundationLib
import SANPLLibrary
import XCTest
@testable import BLIK

final class BLIKSummaryPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var SUT: BLIKSummaryPresenterProtocol!
    private var view: BLIKSummaryViewControllerMock!
    private var coordinator: BLIKSummaryCoordinatorMock?
    @DecodeFile(name: "getTrnToConfResponse")
    private var transaction: GetTrnToConfDTO
    
    override func setUp() {
        super.setUp()
        dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: BLIKSummaryPresenterProtocol.self)
        coordinator = dependencies.resolve(for: BLIKSummaryCoordinatorProtocol.self) as? BLIKSummaryCoordinatorMock
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
        XCTAssertTrue(view.operativeSummaryStandardBodyItemViewModels?.count == 4)
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
            $0.title == "pl_blik_summAnothCode"
        }
        XCTAssertNotNil(viewModel)
        viewModel?.action()
        XCTAssertTrue(coordinator?.goToMakeAnotherPaymentCalled == true)
    }
}

private extension BLIKSummaryPresenterTests {
    func setUpDependencies() {
        dependencies.register(for: BLIKSummaryCoordinatorProtocol.self) { [unowned self] _ in
            let mock = BLIKSummaryCoordinatorMock()
            self.coordinator = mock
            return mock
        }
        dependencies.register(for: UseCaseHandler.self) { _ in
            UseCaseHandler(maxConcurrentOperationCount: 8)
        }
        dependencies.register(for: BLIKSummaryPresenterProtocol.self) { [unowned self] resolver in
            let transaction = try! TransactionMapper().map(dto: self.transaction)
            let presenter = BLIKSummaryPresenter(
                dependenciesResolver: resolver,
                viewModel: BLIKTransactionViewModel(transaction: transaction)
            )
            self.view = BLIKSummaryViewControllerMock(presenter: presenter)
            presenter.view = self.view
            return presenter
        }
    }
}
