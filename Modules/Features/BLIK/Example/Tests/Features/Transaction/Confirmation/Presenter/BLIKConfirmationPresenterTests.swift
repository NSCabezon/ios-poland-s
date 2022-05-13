@testable import BLIK
import CoreFoundationLib
import SANPLLibrary
import XCTest

final class BLIKConfirmationPresenterTests: XCTestCase {
    
    private var SUT: BLIKConfirmationPresenterProtocol!
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var view: BLIKConfirmationViewMock!
    
    @DecodeFile(name: "getTrnToConfResponse")
    private var transaction: GetTrnToConfDTO
    private var viewModel: BLIKTransactionViewModel!
    private var viewModelSource: BLIKTransactionViewModelSource = .needsToBeFetched

    override func setUp() {
        super.setUp()
        do {
            let mapper = TransactionMapper()
            let trn = try mapper.map(dto: transaction)
            viewModel = BLIKTransactionViewModel(transaction: trn)
        } catch {
            XCTFail()
        }
        viewModelSource = .prefetched(viewModel)
        self.dependencies = DependenciesDefault()
        setUpDependencies()
        SUT = dependencies.resolve(for: BLIKConfirmationPresenterProtocol.self)
        view = BLIKConfirmationViewMock()
        SUT.view = view
    }
    
    override func tearDown() {
        super.tearDown()
        self.SUT = nil
        self.dependencies = nil
        viewModel = nil
        view = nil
    }
    
    func test_confirmation_presenter_set_up() {
        SUT.viewDidLoad()
        
        XCTAssertTrue(view.updateCounterCalled)
        XCTAssertEqual(view.viewModel?.transferType, .blikWebPurchases)
        XCTAssertEqual(view.viewModel?.dateString, "28.06.2021")
        XCTAssertEqual(view.viewModel?.transferTypeString, localized("pl_blik_text_shopOnlineStatus"))
        XCTAssertEqual(view.viewModel?.address, "Sklep Miastowa 8 Kraków")
        
    }
    
    func test_initial_timer_time_for_type_blikWebPurchases() {
        dependencies.register(for: BLIKTransactionViewModelProviding.self) { [unowned self] resolver in
            let transaction = Transaction.stub(
                transferType: .blikWebPurchases,
                transactionRawValue: self.transaction
            )
            return BLIKTransactionViewModelProviderMock(transaction: transaction)
        }
        SUT.viewDidLoad()
        XCTAssertEqual(view.viewModel?.transferType, .blikWebPurchases)
        XCTAssertEqual(round(view.remainingDuration), BLIK_WEB_PURCHASE_DURATION)
        XCTAssertEqual(round(view.totalDuration), BLIK_WEB_PURCHASE_DURATION)
    }
    
    func test_initial_timer_time_for_other_type_than_blikWebPurchases() {
        dependencies.register(for: BLIKTransactionViewModelProviding.self) { [unowned self] resolver in
            let transaction = Transaction.stub(
                transferType: .blikAtmWithdrawal,
                transactionRawValue: self.transaction
            )
            return BLIKTransactionViewModelProviderMock(transaction: transaction)
        }
        SUT.viewDidLoad()
        XCTAssertEqual(view.viewModel?.transferType, .blikAtmWithdrawal)
        XCTAssertEqual(round(view.remainingDuration), BLIK_OTHER_DURATION)
        XCTAssertEqual(round(view.totalDuration), BLIK_OTHER_DURATION)
    }
}

private extension BLIKConfirmationPresenterTests {
    
    func setUpDependencies() {
        
        dependencies.register(for: BLIKTransactionViewModelProviding.self) { [viewModelSource] resolver in
            switch viewModelSource {
            case let .prefetched(viewModel):
                return PrefetchedBLIKTransactionViewModelProvider(viewModel: viewModel)
            case .needsToBeFetched:
                return BLIKTransactionViewModelAsyncProvider(dependenciesResolver: resolver)
            }
        }
        
        dependencies.register(for: UseCaseHandler.self) { resolver in
            UseCaseHandler()
        }
    
        dependencies.register(for: BLIKConfirmationPresenterProtocol.self) { resolver in
            BLIKConfirmationPresenter(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: BLIKConfirmationViewProtocol.self) { resolver in
            BLIKConfirmationViewMock()
        }
        
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: CancelBLIKTransactionProtocol.self) { resolver in
            CancelBLIKTransactionUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PLBLIKManagerProtocol.self) { resolver in
            MockBLIKManager()
        }
        
        dependencies.register(for: UseCaseHandler.self) { _ in
            return UseCaseHandler(maxConcurrentOperationCount: 8)
        }
    }
}
