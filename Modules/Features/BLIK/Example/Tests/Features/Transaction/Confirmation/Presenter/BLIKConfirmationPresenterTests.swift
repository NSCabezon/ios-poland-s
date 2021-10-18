import Commons
@testable import BLIK
import DomainCommon
import SANPLLibrary
import XCTest

class BLIKConfirmationPresenterTests: XCTestCase {
    
    private var SUT: BLIKConfirmationPresenterProtocol!
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var view: BLIKConfirmationViewMock!
    
    @DecodeFile(name: "getTrnToConfResponse")
    private var transaction: GetTrnToConfDTO
    private var viewModel: BLIKTransactionViewModel!

    override func setUp() {
        super.setUp()
        do {
            let mapper = TransactionMapper()
            let trn = try mapper.map(dto: transaction)
            viewModel = BLIKTransactionViewModel(transaction: trn)
        } catch {
            XCTFail()
        }

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
}

private extension BLIKConfirmationPresenterTests {
    
    func setUpDependencies() {
    
        dependencies.register(for: BLIKConfirmationPresenterProtocol.self) {[viewModel] resolver in
            BLIKConfirmationPresenter(dependenciesResolver: resolver, viewModel: viewModel)
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
