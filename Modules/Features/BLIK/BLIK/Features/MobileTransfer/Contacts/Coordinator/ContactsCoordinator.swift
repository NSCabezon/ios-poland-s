import UI
import Models
import Commons
import Contacts
import PLUI
import PLCommonOperatives

protocol ContactsCoordinatorProtocol {
    func showForm(with accounts: [SelectableAccountViewModel], contact: Contact?)
    func pop()
    func showAccountSelector(with accounts: [SelectableAccountViewModel], contact: Contact?)
}

final class ContactsCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    weak var selectableContactDelegate: FormContactSelectable?

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         selectableContactDelegate: FormContactSelectable? = nil) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.selectableContactDelegate = selectableContactDelegate
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: ContactsViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ContactsCoordinator: ContactsCoordinatorProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAccountSelector(with accounts: [SelectableAccountViewModel], contact: Contact?) {
        let coordinator = AccountsForDebitCoordinator(dependenciesResolver: dependenciesEngine,
                                                      navigationController: navigationController,
                                                      viewModels: accounts,
                                                      contact: contact,
                                                      sourceView: .contacts,
                                                      selectableAccountDelegate: nil)
        
        coordinator.start()
    }

    func showForm(with accounts: [SelectableAccountViewModel], contact: Contact?) {
        let coordinator = MobileTransferFormCoordinator(dependenciesResolver: dependenciesEngine,
                                                        navigationController: navigationController,
                                                        accounts: accounts,
                                                        contact: contact)
        coordinator.start()
    }
}

/**
 #Register Scene depencencies.
*/

private extension ContactsCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: ContactsCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: ContactsPresenterProtocol.self) { [weak self] resolver in
            return ContactsPresenter(dependenciesResolver: resolver, selectableContactDelegate: self?.selectableContactDelegate)
        }
         
        self.dependenciesEngine.register(for: ContactsViewController.self) { resolver in
            var presenter = resolver.resolve(for: ContactsPresenterProtocol.self)
            let viewController = ContactsViewController(
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        
        self.dependenciesEngine.register(for: GetContactsUseCaseProtocol.self) { _ in
            return GetContactsUseCase(contactStore: CNContactStore(), contactMapper: ContactMapper())
        }
        
        self.dependenciesEngine.register(for: PhoneVerificationProtocol.self) { resolver in
            return PhoneVerificationUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetAccountsForDebitProtocol.self) { resolver in
            return GetAccountsForDebitUseCase(transactionType: .mobileTransfer, dependenciesResolver: resolver)
        }
    }
}
