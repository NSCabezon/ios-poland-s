import UI
import Models
import Commons
import PLUI

public protocol MobileTransferFormCoordinatorProtocol {
    func pop()
    func closeProcess()
    func showAccountSelector(with accounts: [SelectableAccountViewModel])
    func showConfirmation(viewModel: MobileTransferViewModel, isDstAccInternal: Bool, dstAccNo: String)
    func showContacts()
}

protocol FormAccountSelectable: AnyObject {
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel])
}

protocol FormContactSelectable: AnyObject {
    func updateViewModel(with updatedViewModel: Contact?)
}

public final class MobileTransferFormCoordinator: ModuleCoordinator {
    
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accounts: [SelectableAccountViewModel]
    private let contact: Contact?
    weak var delegate: MobileTransferFormAccountAndContactSelectable?

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         accounts: [SelectableAccountViewModel],
         contact: Contact? = nil) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.accounts = accounts
        self.contact = contact
        setupDependencies()
    }
    
    public func start() {
        let presenter = MobileTransferFormPresenter(dependenciesResolver: dependenciesEngine, accounts: accounts, contact: contact, formValidator: MobileTransferFormValidator())
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

    public func showAccountSelector(with accounts: [SelectableAccountViewModel]) {
        let coordinator = AccountsForDebitCoordinator(dependenciesResolver: dependenciesEngine,
                                                      navigationController: navigationController,
                                                      viewModels: accounts,
                                                      contact: contact,
                                                      sourceView: .form,
                                                      selectableAccountDelegate: self)
        
        coordinator.start()
    }
    
    public func closeProcess() {
        let blikHomeVC = navigationController?.viewControllers.reversed().first(where: { $0 is BLIKHomeViewController })
        
        guard let blikHomeViewController = blikHomeVC else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        self.navigationController?.popToViewController(blikHomeViewController, animated: true)
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
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel]) {
        delegate?.updateViewModel(with: updatedViewModel)
    }
}

extension MobileTransferFormCoordinator: FormContactSelectable {
    func updateViewModel(with updatedViewModel: Contact?) {
        delegate?.updateViewModel(with: updatedViewModel)
    }
}
