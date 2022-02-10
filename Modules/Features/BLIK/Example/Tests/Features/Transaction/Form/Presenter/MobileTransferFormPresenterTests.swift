import CoreFoundationLib
@testable import BLIK
import CoreFoundationLib
import PLUI
import PLCommons
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
        let id = "1"
        let accountName = "Konto jakie chcę"
        let accountNumber = "12 3456 7890 1234 5678 9012"
        let availableFunds = Money(amount: 1500, currency: "PLN")
        let defaultForPayments = true
        let type: AccountForDebit.AccountType = .PERSONAL
        let accountSequenceNumber = 1
        let accountType = 1
        let accounts = AccountForDebit(id: id,
                                       name: accountName,
                                       number: accountNumber,
                                       availableFunds: availableFunds,
                                       defaultForPayments: defaultForPayments,
                                       type: type,
                                       accountSequenceNumber: accountSequenceNumber,
                                       accountType: accountType)
        dependencies = DependenciesDefault()
        setUpDependencies(account: accounts)
        queue = DispatchQueue(label: "MobileTransferFormPresenterTests")
        SUT = dependencies.resolve(for: MobileTransferFormPresenterProtocol.self)
        view = MobileTransferFormViewMock()
        SUT.view = view
        
        // when
        let account = SUT.getSelectedAccount()
        
        // then
        XCTAssertEqual(account?.id, id)
        XCTAssertEqual(account?.name, accountName)
        XCTAssertEqual(account?.number, accountNumber)
        XCTAssertEqual(account?.availableFunds, availableFunds)
        XCTAssertEqual(account?.defaultForPayments, defaultForPayments)
        XCTAssertEqual(account?.type, type)
        XCTAssertEqual(account?.accountSequenceNumber, accountSequenceNumber)
        XCTAssertEqual(account?.accountType, accountType)
    }
    
}

private extension MobileTransferFormPresenterTests {
    func setUpDependencies(account: AccountForDebit) {
        dependencies.register(for: MobileTransferFormPresenterProtocol.self) { resolver in
            return MobileTransferFormPresenter(dependenciesResolver: resolver,
                                               accounts: [account],
                                               contact: Contact(fullName: "Jan Nowak",
                                                                phoneNumber: "123 456 789"),
                                               selectedAccountNumber: "",
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
