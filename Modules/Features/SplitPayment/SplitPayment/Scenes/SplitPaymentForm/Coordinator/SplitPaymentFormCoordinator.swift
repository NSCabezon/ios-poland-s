//
//  SplitPaymentFormCoordinator.swift
//  SplitPayment
//
//  Created by 187830 on 14/12/2021.
//

import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import PLUI

protocol SplitPaymentFormCoordinatorProtocol {
    func pop()
    func closeProcess()
    func showAccountSelector(selectedAccountNumber: String)
    func showConfiramtion(model: SplitPaymentModel)
    func showRecipientSelection()
    func updateAccounts(accounts: [AccountForDebit])
}

protocol FormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

final class SplitPaymentFormCoordinator {
    var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    private weak var accountSelectableDelegate: SplitPaymentFormAccountSelectable?
    private weak var recipientSelectorDelegate: RecipientSelectorDelegate?
    weak var accountUpdateDelegate: SplitPaymentAccountSelectorCoordinatorUpdatable?

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
        let controller = self.dependenciesEngine.resolve(for: SplitPaymentFormViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SplitPaymentFormCoordinator: SplitPaymentFormCoordinatorProtocol {
    func pop() {
        if let accountSelectorViewController = navigationController?.viewControllers.first(where: { $0 is AccountSelectorViewProtocol } ) as? AccountSelectorViewProtocol {
            let mapper = SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
            let models = accounts.compactMap({ try? mapper.map($0, selectedAccountNumber: nil) })
            accountSelectorViewController.setViewModels(models)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func closeProcess() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showAccountSelector(selectedAccountNumber: String) {
        let coordinator = SplitPaymentAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber,
            sourceView: .form,
            selectableAccountDelegate: self
        )
        coordinator.start()
    }
    
    func showConfiramtion(model: SplitPaymentModel) {
        // TODO: Show confirmation
    }
    
    func showRecipientSelection() {
        let recipientSelectionCoordinator = RecipientSelectionCoordinator(
            dependenciesResolver: dependenciesEngine,
            delegate: self,
            navigationController: navigationController)
        recipientSelectionCoordinator.start()
    }
    
    func updateAccounts(accounts: [AccountForDebit]) {
        self.accounts = accounts
        accountUpdateDelegate?.updateAccounts(with: accounts)
    }
}

private extension SplitPaymentFormCoordinator {
    func setupDependencies() {
        
        dependenciesEngine.register(for: SplitPaymentValidating.self) { resolver in
            SplitPaymentValidator(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
        dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        dependenciesEngine.register(for: SplitPaymentFormCoordinatorProtocol.self) { _ in
            self
        }
        
        dependenciesEngine.register(for: SplitPaymentFormPresenterProtocol.self) { [accounts, selectedAccountNumber] resolver in
            SplitPaymentFormPresenter(
                dependenciesResolver: resolver,
                accounts: accounts,
                selectedAccountNumber: selectedAccountNumber
            )
        }
        dependenciesEngine.register(for: SplitPaymentFormViewController.self) { [weak self] resolver in
            let presenter = resolver.resolve(for: SplitPaymentFormPresenterProtocol.self)
            self?.accountSelectableDelegate = presenter
            self?.recipientSelectorDelegate = presenter
            let viewController = SplitPaymentFormViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension SplitPaymentFormCoordinator: FormAccountSelectable {
    public func updateSelectedAccountNumber(number: String) {
        accountSelectableDelegate?.updateSelectedAccountNumber(number: number)
    }
}

extension SplitPaymentFormCoordinator: RecipientSelectorDelegate {
    func didSelectRecipient(_ recipient: Recipient) {
        recipientSelectorDelegate?.didSelectRecipient(recipient)
    }
}
