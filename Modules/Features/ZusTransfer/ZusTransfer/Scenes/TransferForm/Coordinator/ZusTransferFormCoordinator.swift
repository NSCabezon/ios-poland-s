//
//  ZusTransferFormCoordinator.swift
//  ZusTransfer
//
//  Created by 187830 on 14/12/2021.
//

import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import PLUI

protocol ZusTransferFormCoordinatorProtocol {
    func pop()
    func closeProcess()
    func showAccountSelector(selectedAccountNumber: String)
    func showConfiramtion(model: ZusTransferModel)
    func showRecipientSelection(with maskAccount: String)
    func updateAccounts(accounts: [AccountForDebit])
}

public protocol FormAccountSelectable: AnyObject {
    func updateSelectedAccountNumber(number: String)
}

public final class ZusTransferFormCoordinator: ModuleCoordinator {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var accounts: [AccountForDebit]
    private let selectedAccountNumber: String
    private let validationMask: String
    private weak var accountSelectableDelegate: ZusTransferFormAccountSelectable?
    private weak var recipientSelectorDelegate: RecipientSelectorDelegate?
    weak var accountUpdateDelegate: ZusAccountSelectorCoordinatorUpdatable?

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        accounts: [AccountForDebit],
        selectedAccountNumber: String,
        validationMask: String
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.validationMask = validationMask
        setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: ZusTransferFormViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ZusTransferFormCoordinator: ZusTransferFormCoordinatorProtocol {
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
        let coordinator = ZusAccountSelectorCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber,
            validationMask: validationMask,
            sourceView: .form,
            selectableAccountDelegate: self
        )
        coordinator.start()
    }
    
    func showConfiramtion(model: ZusTransferModel) {
        let coordinator = ZusTransferConfirmationCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            model: model
        )
        coordinator.start()
    }
    
    func showRecipientSelection(with maskAccount: String) {
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

private extension ZusTransferFormCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusTransferValidating.self) { resolver in
            ZusTransferValidator(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            ConfirmationDialogFactory()
        }
        dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
        dependenciesEngine.register(for: ZusTransferFormCoordinatorProtocol.self) { _ in
            self
        }
        
        dependenciesEngine.register(for: ZusTransferFormPresenterProtocol.self) { [accounts, selectedAccountNumber, validationMask] resolver in
            ZusTransferFormPresenter(
                dependenciesResolver: resolver,
                accounts: accounts,
                selectedAccountNumber: selectedAccountNumber,
                maskAccount: validationMask
            )
        }
        dependenciesEngine.register(for: ZusTransferFormViewController.self) { [weak self] resolver in
            let presenter = resolver.resolve(for: ZusTransferFormPresenterProtocol.self)
            self?.accountSelectableDelegate = presenter
            self?.recipientSelectorDelegate = presenter
            let viewController = ZusTransferFormViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension ZusTransferFormCoordinator: FormAccountSelectable {
    public func updateSelectedAccountNumber(number: String) {
        accountSelectableDelegate?.updateSelectedAccountNumber(number: number)
    }
}

extension ZusTransferFormCoordinator: RecipientSelectorDelegate {
    func didSelectRecipient(_ recipient: Recipient) {
        recipientSelectorDelegate?.didSelectRecipient(recipient)
    }
}
