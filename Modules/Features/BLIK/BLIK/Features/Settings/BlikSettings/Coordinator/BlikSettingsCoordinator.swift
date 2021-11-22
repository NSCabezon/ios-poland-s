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
    func showAliasPaymentSettings()
    func showPhoneTransferSettings()
    func showTransferLimitsSettings()
    func showOtherSettings()
    func close()
    func closeToGlobalPosition()
    func showLimitUpdateSuccessAndClose()
    func goBackToGlobalPosition()
}

final class BlikSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.wallet = wallet
        setUpDependencies()
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
    func showAliasPaymentSettings() {
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
            wallet: wallet
        )
        coordinator.start()
    }
    
    func showTransferLimitsSettings() {
        let presenter = TransactionLimitPresenter(
            dependenciesResolver: dependenciesEngine,
            wallet: wallet,
            viewModelMapper: TransactionLimitViewModelMapper(
                amountFormatterWithCurrency: .PLAmountNumberFormatter,
                amountFormatterWithoutCurrency: .PLAmountNumberFormatterWithoutCurrency
            ),
            setTransactionsLimitUseCase: SetTransactionsLimitUseCase(
              dependenciesResolver: dependenciesEngine
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
    
    func showLimitUpdateSuccessAndClose() {
        TopAlertController.setup(TopAlertView.self).showAlert(
            localized("pl_blik_text_limitChangedSuccess"),
            alertType: .info,
            position: .top
        )
        close()
    }
    
    func goBackToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension BlikSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: GetWalletsActiveProtocol.self) { resolver in
            return GetWalletsActiveUseCase(dependenciesResolver: resolver)
        }
    }
}
