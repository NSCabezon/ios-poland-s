//
//  OtherBlikSettingsCoordinator.swift
//  BLIK
//
//  Created by 186491 on 10/08/2021.
//

import UI
import PLUI
import Models
import Commons
import SANPLLibrary
import PLCommons

protocol OtherBlikSettingsCoordinatorProtocol: ModuleCoordinator {
    func close()
    func goBackToRoot()
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
}

private extension OtherBlikSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: OtherBlikSettingsCoordinatorProtocol.self) { resolver in
            return self
        }
        
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { resolver in
            return ConfirmationDialogFactory()
        }
        
        dependenciesEngine.register(for: BlikCustomerLabelValidating.self) { resolver in
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
