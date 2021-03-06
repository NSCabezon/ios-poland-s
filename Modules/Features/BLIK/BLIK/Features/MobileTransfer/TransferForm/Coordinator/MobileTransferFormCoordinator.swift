import UI
import CoreFoundationLib
import PLUI
import PLCommons

public protocol MobileTransferFormCoordinatorProtocol {
    func pop()
    func closeProcess()
    func showAccountSelector(with accounts: [AccountForDebit], selectedAccountNumber: String)
    func showConfirmation(viewModel: MobileTransferViewModel, isDstAccInternal: Bool, dstAccNo: String)
    func showContacts()
}

protocol FormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(_ number: String)
}

public protocol FormContactSelectable: AnyObject {
    func updateViewModel(with updatedViewModel: MobileContact?)
}

public final class MobileTransferFormCoordinator: ModuleCoordinator {
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    private let contact: MobileContact?
    weak var delegate: MobileTransferFormAccountAndContactSelectable?

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         accounts: [AccountForDebit],
         selectedAccountNumber: String,
         contact: MobileContact? = nil) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.contact = contact
        setupDependencies()
    }
    
    public func start() {
        let presenter = MobileTransferFormPresenter(dependenciesResolver: dependenciesEngine,
                                                    accounts: accounts,
                                                    contact: contact,
                                                    selectedAccountNumber: selectedAccountNumber,
                                                    formValidator: MobileTransferFormValidator())
        delegate = presenter
        let controller = MobileTransferFormViewController(presenter: presenter)
        presenter.view = controller
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension MobileTransferFormCoordinator: MobileTransferFormCoordinatorProtocol {
    
    public func pop() {
        let contactsVC = navigationController?.viewControllers.reversed().first(where: { $0 is ContactsViewController })
    
        guard let contactsViewController = contactsVC else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        self.navigationController?.popToViewController(contactsViewController, animated: true)
    }

    public func showAccountSelector(with accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = AccountsForDebitCoordinator(dependenciesResolver: dependenciesEngine,
                                                      navigationController: navigationController,
                                                      accounts: accounts,
                                                      selectedAccountNumber: selectedAccountNumber,
                                                      contact: contact,
                                                      sourceView: .form,
                                                      selectableAccountDelegate: self)
        
        coordinator.start()
    }
    
    public func closeProcess() {
        let blikHomeVC = navigationController?.viewControllers.reversed().first(where: { $0 is BLIKHomeViewController })
       
        if let blikHomeViewController = blikHomeVC {
            self.navigationController?.popToViewController(blikHomeViewController, animated: true)
            return
        }
        
        let contactsViewControllerIndex = navigationController?.viewControllers.firstIndex {
            $0 is ContactsViewController
        }
        guard let contactsViewControllerIndex = contactsViewControllerIndex,
              let parentController = navigationController?.viewControllers[safe: contactsViewControllerIndex - 1] else {
            navigationController?.popViewController(animated: true)
            return
            
        }
        navigationController?.popToViewController(parentController, animated: true)
    }

    public func showConfirmation(viewModel: MobileTransferViewModel, isDstAccInternal: Bool, dstAccNo: String) {
        let coordinator = MobileTransferConfirmationCoordinator(dependenciesResolver: dependenciesEngine,
                                                                navigationController: navigationController,
                                                                viewModel: viewModel,
                                                                isDstAccInternal: isDstAccInternal,
                                                                dstAccNo: dstAccNo)
        coordinator.start()
    }
    
    public func showContacts() {
        let coordinator = ContactsCoordinator(dependenciesResolver: dependenciesEngine,
                                              navigationController: navigationController,
                                              selectableContactDelegate: self)
        coordinator.start()
    }
}

private extension MobileTransferFormCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: MobileTransferFormCoordinatorProtocol.self) { _ in
            self
        }
        
        self.dependenciesEngine.register(for: P2pAliasProtocol.self) { resolver in
            return P2pAliasUseCase(dependenciesResolver: resolver)
        }
    }
}

extension MobileTransferFormCoordinator: FormAccountSelectable {
    func updateSelectedAccountNumber(_ number: String) {
        delegate?.updateSelectedAccountNumber(with: number)
    }
}

extension MobileTransferFormCoordinator: FormContactSelectable {
    public func updateViewModel(with updatedViewModel: MobileContact?) {
        delegate?.updateViewModel(with: updatedViewModel)
    }
}
