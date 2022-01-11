import UI
import CoreFoundationLib
import Commons
import PLUI
import PLCommons

public protocol AccountSelectorCoordinatorProtocol {
    func pop()
    func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String)
    func closeProcess()
}

public enum SourceView {
    case sendMoney, form
}

public final class AccountSelectorCoordinator: ModuleCoordinator {
    weak public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    private let sourceView: SourceView
    private let charityTransferSettings: CharityTransferSettings
    weak var selectableAccountDelegate: FormAccountSelectable?

    public init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         accounts: [AccountForDebit],
         selectedAccountNumber: String,
         sourceView: SourceView,
         selectableAccountDelegate: FormAccountSelectable? = nil,
         charityTransferSettings: CharityTransferSettings) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.sourceView = sourceView
        self.selectableAccountDelegate = selectableAccountDelegate
        self.charityTransferSettings = charityTransferSettings
        self.setupDependencies()
    }
    
    public func start() {
        let presenter = AccountSelectorPresenter(dependenciesResolver: dependenciesEngine,
                                                 accounts: accounts,
                                                 selectedAccountNumber: selectedAccountNumber,
                                                 sourceView: sourceView,
                                                 selectableDelegate: selectableAccountDelegate)
        let controller = AccountSelectorViewController(presenter: presenter,
                                                       screenLocationConfiguration: .charityTransfer)
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AccountSelectorCoordinator: AccountSelectorCoordinatorProtocol {
    public func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    public func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = CharityTransferFormCoordinator(dependenciesResolver: dependenciesEngine,
                                                         navigationController: navigationController,
                                                         accounts: accounts,
                                                         selectedAccountNumber: selectedAccountNumber,
                                                         charityTransferSettings: charityTransferSettings)
        coordinator.start()
    }
    
    public func closeProcess() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension AccountSelectorCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: AccountSelectorCoordinatorProtocol.self) { _ in
            return self
        }
    }
}
