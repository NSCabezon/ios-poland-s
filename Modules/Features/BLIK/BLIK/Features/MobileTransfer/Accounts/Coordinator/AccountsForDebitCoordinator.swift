import UI
import Models
import Commons
import PLUI

/**
    #Add method that must be handle by the AccountsForDebitCoordinator like 
    navigation between the module scene and so on.
*/
protocol AccountsForDebitCoordinatorProtocol {
    func pop()
    func showTransferForm(accounts: [SelectableAccountViewModel])
    func closeProcess()
}

enum SourceView {
    case contacts
    case form
}

final class AccountsForDebitCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let viewModels: [SelectableAccountViewModel]
    private let contact: Contact?
    private let sourceView: SourceView
    weak var selectableAccountDelegate: FormAccountSelectable?

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         viewModels: [SelectableAccountViewModel],
         contact: Contact?,
         sourceView: SourceView,
         selectableAccountDelegate: FormAccountSelectable?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.viewModels = viewModels
        self.contact = contact
        self.sourceView = sourceView
        self.selectableAccountDelegate = selectableAccountDelegate
        self.setupDependencies()
    }
    
    func start() {
        let presenter = AccountsForDebitPresenter(dependenciesResolver: dependenciesEngine,
                                                  viewModels: viewModels,
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
    
    func showTransferForm(accounts: [SelectableAccountViewModel]) {
        let coordinator = MobileTransferFormCoordinator(dependenciesResolver: dependenciesEngine,
                                                        navigationController: navigationController,
                                                        accounts: accounts,
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
