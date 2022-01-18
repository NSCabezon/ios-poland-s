//
//  AccountForDebitSelectorCoordinator.swift
//  PLUI
//
//  Created by 188216 on 26/11/2021.
//

import UI
import Commons
import PLUI

public protocol AccountForDebitSelectorCoordinatorProtocol {
    func back()
    func didSelectAccount(withAccountNumber accountNumber: String)
    func closeProcess()
}

public final class AccountForDebitSelectorCoordinator: ModuleCoordinator {
    weak public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let mode: AccountForDebitSelectorMode
    private let accounts: [AccountForDebit]
    private let screenLocationConfiguration: AccountSelectorViewController.ScreenLocationConfiguration
    private let selectedAccountNumber: String?
    private weak var accountSelectorDelegate: AccountForDebitSelectorDelegate?

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        mode: AccountForDebitSelectorMode,
        accounts: [AccountForDebit],
        screenLocationConfiguration: AccountSelectorViewController.ScreenLocationConfiguration,
        selectedAccountNumber: String?,
        accountSelectorDelegate: AccountForDebitSelectorDelegate
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.mode = mode
        self.accounts = accounts
        self.screenLocationConfiguration = screenLocationConfiguration
        self.selectedAccountNumber = selectedAccountNumber
        self.accountSelectorDelegate = accountSelectorDelegate
        self.setupDependencies()
    }
    
    public func start() {
        let presenter = AccountForDebitSelectorPresenter(
            dependenciesResolver: dependenciesEngine,
            accounts: accounts,
            selectedAccountNumber: selectedAccountNumber
        )
        let controller = AccountSelectorViewController(
            presenter: presenter,
            screenLocationConfiguration: screenLocationConfiguration
        )
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AccountForDebitSelectorCoordinator: AccountForDebitSelectorCoordinatorProtocol {
    public func back() {
        switch mode {
        case .mustSelectDefaultAccount:
            navigationController?.popToRootViewController(animated: true)
        case .changeDefaultAccount:
            navigationController?.popViewController(animated: true)
        }
    }
    
    public func didSelectAccount(withAccountNumber accountNumber: String) {
        accountSelectorDelegate?.didSelectAccount(withAccountNumber: accountNumber)
        navigationController?.popViewController(animated: true)
    }
    
    public func closeProcess() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension AccountForDebitSelectorCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: AccountForDebitSelectorCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            return SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
    }
}
