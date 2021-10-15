import UI
import Models
import Commons
import PLUI

public protocol AccountSelectorCoordinatorProtocol {
    func pop()
    func showTransferForm(accounts: [SelectableAccountViewModel])
    func closeProcess()
}

public enum SourceView {
    case sendMoney, form
}

public final class AccountSelectorCoordinator: ModuleCoordinator {
    weak public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let viewModels: [SelectableAccountViewModel]
    private let sourceView: SourceView
    weak var selectableAccountDelegate: FormAccountSelectable?

    public init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         viewModels: [SelectableAccountViewModel],
         sourceView: SourceView,
         selectableAccountDelegate: FormAccountSelectable? = nil) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.viewModels = viewModels
        self.sourceView = sourceView
        self.selectableAccountDelegate = selectableAccountDelegate
        self.setupDependencies()
    }
    
    public func start() {
        let presenter = AccountSelectorPresenter(dependenciesResolver: dependenciesEngine,
                                                  viewModels: viewModels,
                                                  sourceView: sourceView, selectableDelegate: selectableAccountDelegate)
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
    
    public func showTransferForm(accounts: [SelectableAccountViewModel]) {
        //TODO: show transfer form - TAP 2015
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
