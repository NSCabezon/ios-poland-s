//
//  BlikLabelSettingsCoordinator.swift
//  BLIK
//
//  Created by 185167 on 23/02/2022.
//

import UI
import PLUI
import CoreFoundationLib
import SANPLLibrary
import PLCommons

protocol BlikCustomerLabelUpdateDelegate: AnyObject {
    func didUpdateBlikCustomerLabel(with newBlikLabel: String)
}

protocol BlikLabelSettingsCoordinatorProtocol: ModuleCoordinator {
    func back()
    func close()
    func notifyAboutLabelUpdateAndGoBack(newBlikLabel: String)
}

final class BlikLabelSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private weak var blikLabelUpdateDelegate: BlikCustomerLabelUpdateDelegate?
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        blikLabelUpdateDelegate: BlikCustomerLabelUpdateDelegate?,
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.blikLabelUpdateDelegate = blikLabelUpdateDelegate
        self.wallet = wallet
        setUpDependencies()
    }
    
    public func start() {
        let presenter = BlikLabelSettingsPresenter(
            wallet: wallet,
            dependenciesResolver: dependenciesEngine
        )
        let viewController = BlikLabelSettingsViewController(presenter: presenter)
        presenter.view = viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension BlikLabelSettingsCoordinator: BlikLabelSettingsCoordinatorProtocol {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func notifyAboutLabelUpdateAndGoBack(newBlikLabel: String) {
        TopAlertController.setup(TopAlertView.self).showAlert(
            localized("pl_blik_text_settingsChangedSuccess"),
            alertType: .info,
            position: .top
        )
        blikLabelUpdateDelegate?.didUpdateBlikCustomerLabel(with: newBlikLabel)
        navigationController?.popViewController(animated: true)
    }
}

private extension BlikLabelSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: BlikLabelSettingsCoordinatorProtocol.self) { _ in
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
