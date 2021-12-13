//
//  AccountSelectorCoordinator.swift
//  PLUI
//
//  Created by 188216 on 26/11/2021.
//

import UI
import Commons
import PLCommons
import PLUI

protocol AccountSelectorCoordinatorProtocol {
    func pop()
    func closeProcess()
}

final class AccountSelectorCoordinator: ModuleCoordinator {
    weak public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accounts: [AccountForDebit]
    private let selectedAccountNumber: String?
    private weak var accountSelectorDelegate: AccountSelectorDelegate?

    public init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         accounts: [AccountForDebit],
         selectedAccountNumber: String?,
         accountSelectorDelegate: AccountSelectorDelegate) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accounts = accounts
        self.selectedAccountNumber = selectedAccountNumber
        self.accountSelectorDelegate = accountSelectorDelegate
        self.setupDependencies()
    }
    
    public func start() {
        let presenter = AccountSelectorPresenter(dependenciesResolver: dependenciesEngine,
                                                 accounts: accounts,
                                                 selectedAccountNumber: selectedAccountNumber,
                                                 accountSelectorDelegate: accountSelectorDelegate)
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
    
    public func closeProcess() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension AccountSelectorCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: AccountSelectorCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            return SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
    }
}
