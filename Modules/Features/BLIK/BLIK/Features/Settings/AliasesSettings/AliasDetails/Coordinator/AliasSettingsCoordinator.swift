//
//  AliasSettingsCoordinator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/09/2021.
//

import UI
import PLUI
import CoreFoundationLib
import Commons
import SANPLLibrary
import PLCommons

protocol AliasSettingsCoordinatorProtocol: ModuleCoordinator {
    func showAliasRenameScreen()
    func showAliasDeletionScreen()
    func showAliasChangeDateScreen()
    func goBack()
}

final class AliasSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let alias: BlikAlias

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        alias: BlikAlias
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.alias = alias
        setUpDependencies()
    }
    
    public func start() {
        let presenter = AliasSettingsPresenter(
            dependenciesResolver: dependenciesEngine,
            alias: alias
        )
        let controller = AliasSettingsViewController(presenter: presenter)
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AliasSettingsCoordinator: AliasSettingsCoordinatorProtocol {
    func showAliasRenameScreen() {
        let coordinator = RenameAliasCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            alias: alias
        )
        coordinator.start()
    }
    
    func showAliasChangeDateScreen() {
        let coordinator = AliasDateChangeCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            alias: alias
        )
        coordinator.start()
    }
    
    
    
    func showAliasDeletionScreen() {
        let coordinator = DeleteAliasCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            alias: alias
        )
        coordinator.start()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private extension AliasSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: AliasSettingsCoordinatorProtocol.self) { resolver in
            return self
        }
        
        dependenciesEngine.register(for: AliasSettingsViewModelMapping.self) { resolver in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
            return AliasSettingsViewModelMapper(dateFormatter: dateFormatter)
        }
    }
}

