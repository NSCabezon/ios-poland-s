import Commons
@testable import BLIK
import DomainCommon
import PLUI
import SANPLLibrary
import XCTest

class MobileTransferFormPresenterTests: XCTestCase {
    private var dependencies: (DependenciesResolver & DependenciesInjector)!
    private var queue: DispatchQueue!
    private var SUT: MobileTransferFormPresenterProtocol!
    private var view: MobileTransferFormViewMock!
    
    override func tearDown() {
        super.tearDown()
        dependencies = nil
        queue = nil
        SUT = nil
    }
    
    func test_get_selected_account() {
        // given
        let accountName = "Konto jakie chcę"
        let accountNumber = "12 3456 7890 1234 5678 9012"
        let unformattedAccountNumber = "1234567890123456789012"
        let availableFunds = "1500"
        let isSelected = true
        let accountViewModel = SelectableAccountViewModel(
            name: accountName,
            accountNumber: accountNumber,
            accountNumberUnformatted: unformattedAccountNumber,
            availableFunds: availableFunds,
            type: .PERSONAL,
            accountSequenceNumber: 9,
            accountType: 101,
            isSelected: true
        )
        dependencies = DependenciesDefault()
        setUpDependencies(viewModel: accountViewModel)
        queue = DispatchQueue(label: "MobileTransferFormPresenterTests")
        SUT = dependencies.resolve(for: MobileTransferFormPresenterProtocol.self)
        view = MobileTransferFormViewMock()
        SUT.view = view
        
        // when
        let account = SUT.getSelectedAccountViewModel()
        
        // then
        XCTAssertEqual(account?.name, accountName)
        XCTAssertEqual(account?.accountNumber, accountNumber)
        XCTAssertEqual(account?.availableFunds, availableFunds)
        XCTAssertEqual(account?.isSelected, isSelected)
        XCTAssertEqual(account?.accountNumberUnformatted, unformattedAccountNumber)
    }
    
}

private extension MobileTransferFormPresenterTests {
    func setUpDependencies(viewModel: SelectableAccountViewModel) {
        dependencies.register(for: MobileTransferFormPresenterProtocol.self) { resolver in
            return MobileTransferFormPresenter(dependenciesResolver: resolver,
                                               accounts: [viewModel],
                                               contact: Contact(fullName: "Jan Nowak",
                                                                phoneNumber: "123 456 789"),
                                               formValidator: MobileTransferFormValidator())
        }
        
        dependencies.register(for: P2pAliasProtocol.self) { resolver in
            P2pAliasUseCase(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PLManagersProviderProtocol.self) { resolver in
            PLManagersProviderMock(dependenciesResolver: resolver)
        }
        
        dependencies.register(for: PLBLIKManagerProtocol.self) { resolver in
            MockBLIKManager()
        }
    }
}
