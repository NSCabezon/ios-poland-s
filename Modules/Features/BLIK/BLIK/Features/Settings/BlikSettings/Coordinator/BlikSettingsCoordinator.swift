//
//  BlikSettingsCoordinator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 20/07/2021.
//

import UI
import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary

protocol BlikSettingsCoordinatorProtocol: ModuleCoordinator {
    func showAliasPaymentSettings()
    func showPhoneTransferSettings()
    func showTransferLimitsSettings(with params: WalletParams)
    func showOtherSettings()
    func back()
    func closeToGlobalPosition()
    func showLimitUpdateSuccess()
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
        var presenter = dependenciesEngine.resolve(for: BlikSettingsPresenterProtocol.self)
        let controller = BlikSettingsViewController(
            presenter: presenter,
            viewModels: BlikSettingsViewModel.allCases
        )
        presenter.view = controller
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
    
    func showTransferLimitsSettings(with params: WalletParams) {
        let presenter = TransactionLimitPresenter(
            dependenciesResolver: dependenciesEngine,
            wallet: wallet,
            walletParams: params,
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
    
    func back() {
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
    
    func showLimitUpdateSuccess() {
        TopAlertController.setup(TopAlertView.self).showAlert(
            localized("pl_blik_text_limitChangedSuccess"),
            alertType: .info,
            position: .top
        )
    }
}

private extension BlikSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: GetWalletsActiveProtocol.self) { resolver in
            return GetWalletsActiveUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: BlikSettingsCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: LoadWalletParamsUseCaseProtocol.self) { resolver in
            return LoadWalletParamsUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: BlikSettingsPresenterProtocol.self) { resolver in
            return BlikSettingsPresenter(dependenciesResolver: resolver)
        }
    }
}
