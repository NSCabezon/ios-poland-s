import UI
import CoreFoundationLib
import PLCommons
import PLUI

protocol CharityTransferFormCoordinatorProtocol {
    func pop()
    func closeProcess()
    func showAccountSelector(selectedAccountNumber: String)
    func showConfirmation(with model: CharityTransferModel)
}

public protocol FormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

public final class CharityTransferFormCoordinator: ModuleCoordinator {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    weak var delegate: CharityTransferFormAccountSelectable?
    private let charityTransferSettings: CharityTransferSettings
    
    private let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
    
    public init(dependenciesResolver: DependenciesResolver,
                navigationController: UINavigationController?,
                accounts: [AccountForDebit],
                selectedAccountNumber: String,
                charityTransferSettings: CharityTransferSettings) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.charityTransferSettings = charityTransferSettings
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
    
    func showAccountSelector(selectedAccountNumber: String) {
        let coordinator = CharityTransferAccountSelectorCoordinator(dependenciesResolver: dependenciesEngine,
                                                     navigationController: navigationController,
                                                     accounts: accounts,
                                                     selectedAccountNumber: selectedAccountNumber,
                                                     sourceView: .form, selectableAccountDelegate: self,
                                                     charityTransferSettings: charityTransferSettings)
        coordinator.start()
    }
    
    func showConfirmation(with model: CharityTransferModel) {
        let coordinator = CharityTransferConfirmationCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            model: model
        )
        coordinator.start()
    }
}

private extension CharityTransferFormCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: CharityTransferFormCoordinatorProtocol.self) { _ in
            self
        }
        
        self.dependenciesEngine.register(for: CharityTransferFormPresenterProtocol.self) { [accounts, selectedAccountNumber, charityTransferSettings] resolver in
            return CharityTransferFormPresenter(dependenciesResolver: resolver,
                                                accounts: accounts,
                                                selectedAccountNumber: selectedAccountNumber,
                                                formValidator: CharityTransferValidator(),
                                                charityTransferSettings: charityTransferSettings)
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
    public func updateSelectedAccountNumber(number: String) {
        delegate?.updateSelectedAccountNumber(number: number)
    }
}
