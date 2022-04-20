import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import PLUI
import PLCommonOperatives

protocol ZusSmeTransferFormCoordinatorProtocol {
    func pop()
    func closeProcess()
    func showAccountSelector(selectedAccountNumber: String)
    func showRecipientSelection(with maskAccount: String?)
    func updateAccounts(accounts: [AccountForDebit])
    func showConfiramtion(model: ZusSmeTransferModel)
}

protocol FormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

final class ZusSmeTransferFormCoordinator {
    private var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    private weak var accountSelectableDelegate: ZusSmeTransferFormAccountSelectable?
    private weak var recipientSelectorDelegate: RecipientSelectorDelegate?
    weak var accountUpdateDelegate: ZusSmeAccountSelectorCoordinatorUpdatable?

    init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        accounts: [AccountForDebit],
        selectedAccountNumber: String
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: ZusSmeTransferFormViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ZusSmeTransferFormCoordinator: ZusSmeTransferFormCoordinatorProtocol {
    func pop() {
        if let accountSelectorViewController = navigationController?.viewControllers.first(where: { $0 is AccountSelectorViewProtocol } ) as? AccountSelectorViewProtocol {
            let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
            let models = accounts.compactMap { try? mapper.map($0, selectedAccountNumber: nil) }
            accountSelectorViewController.setViewModels(models)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func closeProcess() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showAccountSelector(selectedAccountNumber: String) {
        let coordinator = ZusSmeAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber,
            sourceView: .form,
            selectableAccountDelegate: self
        )
        coordinator.start()
    }
    
    func showConfiramtion(model: ZusSmeTransferModel) {
        let coordinator = ZusSmeTransferConfirmationCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            model: model
        )
        coordinator.start()
    }
    
    func showRecipientSelection(with maskAccount: String?) {
        let recipientSelectionCoordinator = RecipientSelectionCoordinator(
            dependenciesResolver: dependenciesEngine,
            delegate: self,
            navigationController: navigationController,
            maskAccount: maskAccount)
        recipientSelectionCoordinator.start()
    }
    
    func updateAccounts(accounts: [AccountForDebit]) {
        self.accounts = accounts
        accountUpdateDelegate?.updateAccounts(with: accounts)
    }
}

private extension ZusSmeTransferFormCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
        dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        dependenciesEngine.register(for: ZusSmeTransferFormCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: VATAccountDetailsMapping.self) { _ in
            VATAccountDetailsMapper()
        }
        dependenciesEngine.register(for: ZusSmeTransferValidating.self) { resolver in
            ZusSmeTransferValidator(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: GetPopularAccountsUseCase.self) { resolver in
            GetPopularAccountsUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: GetVATAccountUseCase.self) { resolver in
            GetVATAccountUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: ZusSmeTransferFormPresenterProtocol.self) { [accounts, selectedAccountNumber] resolver in
            ZusSmeTransferFormPresenter(
                dependenciesResolver: resolver,
                accounts: accounts,
                selectedAccountNumber: selectedAccountNumber
            )
        }
        dependenciesEngine.register(for: ZusSmeTransferFormViewController.self) { [weak self] resolver in
            let presenter = resolver.resolve(for: ZusSmeTransferFormPresenterProtocol.self)
            self?.accountSelectableDelegate = presenter
            self?.recipientSelectorDelegate = presenter
            let viewController = ZusSmeTransferFormViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension ZusSmeTransferFormCoordinator: FormAccountSelectable {
    func updateSelectedAccountNumber(number: String) {
        accountSelectableDelegate?.updateSelectedAccountNumber(number: number)
    }
}

extension ZusSmeTransferFormCoordinator: RecipientSelectorDelegate {
    func didSelectRecipient(_ recipient: Recipient) {
        recipientSelectorDelegate?.didSelectRecipient(recipient)
    }
}
