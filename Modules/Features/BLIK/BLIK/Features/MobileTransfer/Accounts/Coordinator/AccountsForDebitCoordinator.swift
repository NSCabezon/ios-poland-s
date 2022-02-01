import UI
import CoreFoundationLib
import CoreFoundationLib
import PLUI
import PLCommons

/**
    #Add method that must be handle by the AccountsForDebitCoordinator like 
    navigation between the module scene and so on.
*/
protocol AccountsForDebitCoordinatorProtocol {
    func pop()
    func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String)
    func closeProcess()
}

enum SourceView {
    case contacts
    case form
}

final class AccountsForDebitCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    private let contact: MobileContact?
    private let sourceView: SourceView
    weak var selectableAccountDelegate: FormAccountSelectable?

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         accounts: [AccountForDebit],
         selectedAccountNumber: String,
         contact: MobileContact?,
         sourceView: SourceView,
         selectableAccountDelegate: FormAccountSelectable?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.contact = contact
        self.sourceView = sourceView
        self.selectableAccountDelegate = selectableAccountDelegate
        self.setupDependencies()
    }
    
    func start() {
        let presenter = AccountsForDebitPresenter(dependenciesResolver: dependenciesEngine,
                                                  accounts: accounts,
                                                  selectedAccountNumber: selectedAccountNumber,
                                                  sourceView: sourceView,
                                                  selectableDelegate: selectableAccountDelegate)
        let controller = AccountSelectorViewController(presenter: presenter,
                                                       screenLocationConfiguration: .mobileTransfer)
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AccountsForDebitCoordinator: AccountsForDebitCoordinatorProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = MobileTransferFormCoordinator(dependenciesResolver: dependenciesEngine,
                                                        navigationController: navigationController,
                                                        accounts: accounts,
                                                        selectedAccountNumber: selectedAccountNumber,
                                                        contact: contact)
        
        coordinator.start()
    }
    
    func closeProcess() {
        let blikHomeVC = navigationController?.viewControllers.reversed().first(where: { $0 is BLIKHomeViewController })
       
        guard let blikHomeViewController = blikHomeVC else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        self.navigationController?.popToViewController(blikHomeViewController, animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension AccountsForDebitCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: AccountsForDebitCoordinatorProtocol.self) { _ in
            return self
        }
    }
}
