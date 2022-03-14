import UI
import CoreFoundationLib
import PLUI
import PLCommons

public protocol ZusAccountSelectorCoordinatorProtocol {
    func pop()
    func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String)
    func closeProcess()
}

public protocol ZusAccountSelectorCoordinatorUpdatable: AnyObject {
    func updateAccounts(with accounts: [AccountForDebit])
}

public enum SourceView {
    case sendMoney, form
}

public final class ZusAccountSelectorCoordinator: ModuleCoordinator {
    weak public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    private let sourceView: SourceView
    weak var selectableAccountDelegate: FormAccountSelectable?
    private var presenter: ZusAccountSelectorPresenter?

    public init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         accounts: [AccountForDebit],
         selectedAccountNumber: String,
         sourceView: SourceView,
         selectableAccountDelegate: FormAccountSelectable? = nil) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.sourceView = sourceView
        self.selectableAccountDelegate = selectableAccountDelegate
        self.setupDependencies()
    }
    
    public func start() {
        let presenter = ZusAccountSelectorPresenter(
            dependenciesResolver: dependenciesEngine,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber,
            sourceView: sourceView,
            selectableDelegate: selectableAccountDelegate
        )
        let controller = AccountSelectorViewController(
            presenter: presenter,
            screenLocationConfiguration: .zusTransfer
        )
        self.presenter = presenter
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ZusAccountSelectorCoordinator: ZusAccountSelectorCoordinatorProtocol {
    public func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    public func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = ZusTransferFormCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber
        )
        coordinator.accountUpdateDelegate = self
        coordinator.start()
    }
    
    public func closeProcess() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension ZusAccountSelectorCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusAccountSelectorCoordinatorProtocol.self) { _ in
            return self
        }
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
    }
}

extension ZusAccountSelectorCoordinator: ZusAccountSelectorCoordinatorUpdatable {
    public func updateAccounts(with accounts: [AccountForDebit]) {
        self.accounts = accounts
        presenter?.updateAccounts(accounts: accounts)
    }
}
