//
//  BlikSettingsCoordinator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 20/07/2021.
//

import UI
import Models
import Commons
import SANPLLibrary

protocol BlikSettingsCoordinatorProtocol: ModuleCoordinator {
    func showCodelessPaymentSettings()
    func showPhoneTransferSettings()
    func showTransferLimitsSettings()
    func showOtherSettings()
    func close()
    func closeToGlobalPosition()
}

final class BlikSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let wallet: GetWalletUseCaseOkOutput.Wallet

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        wallet: GetWalletUseCaseOkOutput.Wallet
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.wallet = wallet
    }
    
    public func start() {
        let controller = BlikSettingsViewController(
            coordinator: self,
            viewModels: BlikSettingsViewModel.allCases
        )
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension BlikSettingsCoordinator: BlikSettingsCoordinatorProtocol {
    func showCodelessPaymentSettings() {
        let coordinator = AliasListSettingsCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController
        )
        coordinator.start()
    }
    
    func showPhoneTransferSettings() {
        let coordinator = PhoneTransferSettingsCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            wallet: wallet,
            phoneTransferSettingsFactory: PhoneTransferSettingsFactory(
                dependenciesResolver: dependenciesEngine
            )
        )
        coordinator.start()
    }
    
    func showTransferLimitsSettings() {
        let presenter = TransactionLimitPresenter(
            wallet: wallet,
            viewModelMapper: TransactionLimitViewModelMapper(
                amountFormatterWithCurrency: .PLAmountNumberFormatter,
                amountFormatterWithoutCurrency: .PLAmountNumberFormatterWithoutCurrency
            ),
            setTransactionsLimitUseCase: SetTransactionsLimitUseCase(
                managersProvider: dependenciesEngine.resolve(
                    for: PLManagersProviderProtocol.self
                )
            ),
            validator: TransactionsLimitValidator(),
            coordinator: self)
        let viewController = TransactionLimitViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showOtherSettings() {
        let coordinator = OtherBlikSettingsCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            wallet: wallet
        )
        coordinator.start()
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showEmptyController() {
        let emptyController = UIViewController()
        emptyController.view.backgroundColor = .white
        navigationController?.pushViewController(emptyController, animated: true)
    }
    
    func closeToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}
