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

protocol AccountSelectorCoordinatorProtocol {
    func selectAccount(_ account: AccountForDebit)
    func close()
}

final class AccountSelectorCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let accountSelectionHandler: (AccountForDebit) -> ()
    private let screenLocationConfiguration: AccountSelectorViewController.ScreenLocationConfiguration

    init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        screenLocationConfiguration: AccountSelectorViewController.ScreenLocationConfiguration,
        accountSelectionHandler: @escaping (AccountForDebit) -> ()
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.accountSelectionHandler = accountSelectionHandler
        self.screenLocationConfiguration = screenLocationConfiguration
    }
    
    public func start() {
        let presenter = AccountSelectorPresenter(
            dependenciesResolver: dependenciesEngine,
            coordinator: self,
            loadAccountsUseCase: LoadCustomerAccountsUseCase(
                managersProvider: dependenciesEngine.resolve(for: PLManagersProviderProtocol.self)
            ),
            viewModelMapper: SelectableAccountViewModelMapper(
                amountFormatter: .PLAmountNumberFormatter
            )
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
    func selectAccount(_ account: AccountForDebit) {
        accountSelectionHandler(account)
        close()
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
}
