//
//  OtherBlikSettingsCoordinator.swift
//  BLIK
//
//  Created by 186491 on 10/08/2021.
//

import UI
import PLUI
import CoreFoundationLib
import SANPLLibrary
import PLCommons

protocol OtherBlikSettingsCoordinatorProtocol: ModuleCoordinator {
    func showBlikLabelSettings()
    func showSaveSettingsSuccessAlert()
    func back()
    func close()
}

final class OtherBlikSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    private weak var blikLabelUpdateDelegate: BlikCustomerLabelUpdateDelegate?

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
        let presenter = OtherBlikSettingsPresenter(
            wallet: wallet,
            dependenciesResolver: dependenciesEngine
        )
        let viewController = OtherBlikSettingsViewController(
            presenter: presenter
        )
        presenter.view = viewController
        blikLabelUpdateDelegate = presenter
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension OtherBlikSettingsCoordinator: OtherBlikSettingsCoordinatorProtocol {
    func showBlikLabelSettings() {
        let coordinator = BlikLabelSettingsCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            blikLabelUpdateDelegate: blikLabelUpdateDelegate,
            wallet: wallet
        )
        coordinator.start()
    }
    
    func showSaveSettingsSuccessAlert() {
        TopAlertController.setup(TopAlertView.self).showAlert(
            localized("pl_blik_text_settingsChangedSuccess"),
            alertType: .info,
            position: .top
        )
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension OtherBlikSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: OtherBlikSettingsCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: SaveBlikTransactionDataVisibilityUseCaseProtocol.self) { resolver in
            return SaveBlikTransactionDataVisibilityUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: GetWalletsActiveUseCase.self) { resolver in
            return GetWalletsActiveUseCase(dependenciesResolver: resolver)
        }
    }
}
