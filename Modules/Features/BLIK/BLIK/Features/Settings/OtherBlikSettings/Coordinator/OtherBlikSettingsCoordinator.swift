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
    func close()
    func goBackToRoot()
    func showSaveSettingsSuccessAlert()
}

final class OtherBlikSettingsCoordinator: ModuleCoordinator {
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
        let presenter = OtherBlikSettingsPresenter(
            wallet: wallet,
            dependenciesResolver: dependenciesEngine
        )
        let viewController = OtherBlikSettingsViewController(
            presenter: presenter
        )
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension OtherBlikSettingsCoordinator: OtherBlikSettingsCoordinatorProtocol {
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    func goBackToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showSaveSettingsSuccessAlert() {
        TopAlertController.setup(TopAlertView.self).showAlert(
            localized("pl_blik_text_settingsChangedSuccess"),
            alertType: .info,
            position: .top
        )
    }
}

private extension OtherBlikSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: OtherBlikSettingsCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { _ in
            return ConfirmationDialogFactory()
        }
        
        dependenciesEngine.register(for: BlikCustomerLabelValidating.self) { _ in
            return BlikCustomerLabelValidator()
        }
        
        dependenciesEngine.register(for: SaveBlikCustomerLabelUseCaseProtocol.self) { resolver in
            return SaveBlikCustomerLabelUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: GetWalletsActiveUseCase.self) { resolver in
            return GetWalletsActiveUseCase(dependenciesResolver: resolver)
        }
    }
}
