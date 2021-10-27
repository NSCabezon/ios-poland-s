//
//  AccountSelectorCoordinator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 11/08/2021.
//

import UI
import Models
import Commons
import DataRepository
import SANPLLibrary
import PLUI
import PLCommons
import PLCommonOperatives

protocol AccountSelectorCoordinatorProtocol {
    func selectAccount(_ account: BlikCustomerAccount)
    func close()
}

final class AccountSelectorCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accountSelectionHandler: (BlikCustomerAccount) -> ()
    private let screenLocationConfiguration: AccountSelectorViewController.ScreenLocationConfiguration
    private let accounts: [BlikCustomerAccount]

    init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        screenLocationConfiguration: AccountSelectorViewController.ScreenLocationConfiguration,
        accounts: [BlikCustomerAccount],
        accountSelectionHandler: @escaping (BlikCustomerAccount) -> ()
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accountSelectionHandler = accountSelectionHandler
        self.screenLocationConfiguration = screenLocationConfiguration
        self.accounts = accounts
        self.setupDependencies()
    }
    
    public func start() {
        let presenter = AccountSelectorPresenter(
            dependenciesResolver: dependenciesEngine,
            accounts: accounts
        )
        let controller = AccountSelectorViewController(
            presenter: presenter,
            screenLocationConfiguration: screenLocationConfiguration
        )
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AccountSelectorCoordinator: AccountSelectorCoordinatorProtocol {
    func selectAccount(_ account: BlikCustomerAccount) {
        accountSelectionHandler(account)
        close()
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
}

extension AccountSelectorCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: AccountSelectorCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: SelectableAccountViewModelMapping.self) { _ in
            return SelectableAccountViewModelMapper(amountFormatter: .PLAmountNumberFormatter)
        }
    }
}
