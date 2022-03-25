import UI
import CoreFoundationLib
import PLUI
import PLCommons

protocol ZusSmeAccountSelectorCoordinatorProtocol {
    func pop()
    func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String)
    func closeProcess()
}

protocol ZusSmeAccountSelectorCoordinatorUpdatable: AnyObject {
    func updateAccounts(with accounts: [AccountForDebit])
}

enum SourceView {
    case sendMoney, form
}

final class ZusSmeAccountSelectorCoordinator {
    private let navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var accounts: [AccountForDebit]
    private let selectedAccountNumber: String?
    private let sourceView: SourceView
    private weak var selectableAccountDelegate: FormAccountSelectable?
    private var presenter: ZusSmeAccountSelectorPresenter?

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         accounts: [AccountForDebit],
         selectedAccountNumber: String? = nil,
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
    
    func start() {
        let presenter = ZusSmeAccountSelectorPresenter(
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

extension ZusSmeAccountSelectorCoordinator: ZusSmeAccountSelectorCoordinatorProtocol {
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func showTransferForm(accounts: [AccountForDebit], selectedAccountNumber: String) {
        let coordinator = ZusSmeTransferFormCoordinator(
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

private extension ZusSmeAccountSelectorCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusSmeAccountSelectorCoordinatorProtocol.self) { _ in
            return self
        }
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
    }
}

extension ZusSmeAccountSelectorCoordinator: ZusSmeAccountSelectorCoordinatorUpdatable {
    func updateAccounts(with accounts: [AccountForDebit]) {
        self.accounts = accounts
        presenter?.updateAccounts(accounts: accounts)
    }
}
