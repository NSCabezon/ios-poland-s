import UI
import CoreFoundationLib
import PLUI
import PLCommons

protocol SplitPaymentAccountSelectorCoordinatorProtocol {
    func pop()
    func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String)
    func closeProcess()
}

protocol SplitPaymentAccountSelectorCoordinatorUpdatable: AnyObject {
    func updateAccounts(with accounts: [AccountForDebit])
}

enum SourceView {
    case sendMoney, form
}

final class SplitPaymentAccountSelectorCoordinator: ModuleCoordinator {
    weak public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    private let sourceView: SourceView
    private weak var selectableAccountDelegate: FormAccountSelectable?
    private var presenter: SplitPaymentAccountSelectorPresenter?

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         accounts: [AccountForDebit],
         selectedAccountNumber: String,
         sourceView: SourceView,
         selectableAccountDelegate: FormAccountSelectable? = nil
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.sourceView = sourceView
        self.selectableAccountDelegate = selectableAccountDelegate
        self.setupDependencies()
    }
    
    func start() {
        let presenter = SplitPaymentAccountSelectorPresenter(
            dependenciesResolver: dependenciesEngine,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber,
            sourceView: sourceView,
            selectableDelegate: selectableAccountDelegate
        )
        let controller = AccountSelectorViewController(
            presenter: presenter,
            screenLocationConfiguration: .splitPayment
        )
        self.presenter = presenter
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SplitPaymentAccountSelectorCoordinator: SplitPaymentAccountSelectorCoordinatorProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = SplitPaymentFormCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber
        )
        coordinator.accountUpdateDelegate = self
        coordinator.start()
    }
    
    func closeProcess() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension SplitPaymentAccountSelectorCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: SplitPaymentAccountSelectorCoordinatorProtocol.self) { _ in
            return self
        }
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
    }
}

extension SplitPaymentAccountSelectorCoordinator: SplitPaymentAccountSelectorCoordinatorUpdatable {
    public func updateAccounts(with accounts: [AccountForDebit]) {
        self.accounts = accounts
        presenter?.updateAccounts(accounts: accounts)
    }
}
