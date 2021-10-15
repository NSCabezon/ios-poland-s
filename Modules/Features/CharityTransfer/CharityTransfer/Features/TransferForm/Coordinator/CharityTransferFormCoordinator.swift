import UI
import Commons
import PLCommons
import PLUI

protocol CharityTransferFormCoordinatorProtocol {
    func pop()
    func closeProcess()
    func showAccountSelector()
}

public protocol FormAccountSelectable: AnyObject {
    func updateViewModel(with updatedViewModel: [SelectableAccountViewModel])
}

public final class CharityTransferFormCoordinator: ModuleCoordinator {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var accounts: [SelectableAccountViewModel]
    weak var delegate: CharityTransferFormAccountSelectable?
    
    public init(dependenciesResolver: DependenciesResolver,
                navigationController: UINavigationController?,
                accounts: [SelectableAccountViewModel]) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: CharityTransferFormViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

extension CharityTransferFormCoordinator: CharityTransferFormCoordinatorProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func closeProcess() {
        //TODO: change po to back to Send Money when will be available
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showAccountSelector() {
        let coordinator = AccountSelectorCoordinator(dependenciesResolver: dependenciesEngine,
                                                     navigationController: navigationController,
                                                     viewModels: accounts,
                                                     sourceView: .form, selectableAccountDelegate: self)
        coordinator.start()
    }
}

private extension CharityTransferFormCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: CharityTransferFormCoordinatorProtocol.self) { _ in
            self
        }
        
        let accounts = accounts
        
        self.dependenciesEngine.register(for: CharityTransferFormPresenterProtocol.self) { resolver in
            return CharityTransferFormPresenter(dependenciesResolver: resolver, accounts: accounts)
        }
        
        self.dependenciesEngine.register(for: CharityTransferFormViewController.self) { [weak self] resolver in
            var presenter = resolver.resolve(for: CharityTransferFormPresenterProtocol.self)
            self?.delegate = presenter as? CharityTransferFormPresenter
            let viewController = CharityTransferFormViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension CharityTransferFormCoordinator: FormAccountSelectable {
    public func updateViewModel(with updatedViewModel: [SelectableAccountViewModel]) {
        self.accounts = updatedViewModel
        delegate?.updateViewModel(with: updatedViewModel)
    }
}
