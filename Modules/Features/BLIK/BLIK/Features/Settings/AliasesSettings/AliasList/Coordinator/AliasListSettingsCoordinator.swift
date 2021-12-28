//
//  AliasListSettingsCoordinator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 02/09/2021.
//

import UI
import PLUI
import CoreFoundationLib
import Commons
import SANPLLibrary
import PLCommons

protocol AliasListSettingsCoordinatorProtocol: ModuleCoordinator {
    func showAliasSettings(for alias: BlikAlias)
    func goBack()
}

final class AliasListSettingsCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        setUpDependencies()
    }
    
    public func start() {
        var presenter = dependenciesEngine.resolve(for: AliasListSettingsPresenterProtocol.self)
        let controller = AliasListSettingsViewController(presenter: presenter)
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AliasListSettingsCoordinator: AliasListSettingsCoordinatorProtocol {
    func showAliasSettings(for alias: BlikAlias) {
        let coordinator = AliasSettingsCoordinator(
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

private extension AliasListSettingsCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: AliasListSettingsCoordinatorProtocol.self) { resolver in
            return self
        }
        
        dependenciesEngine.register(for: BlikAliasMapping.self) { resolver in
            return BlikAliasMapper(dateFormatter: PLTimeFormat.YYYYMMDD_HHmmssSSS.createDateFormatter())
        }
        
        dependenciesEngine.register(for: GetAliasesUseCaseProtocol.self) { resolver in
            return GetAliasesUseCase(
                managersProvider: resolver.resolve(for: PLManagersProviderProtocol.self),
                modelMapper: resolver.resolve(for: BlikAliasMapping.self)
            )
        }
        
        dependenciesEngine.register(for: AliasListSettingsViewModelMapping.self) { resolver in
            return AliasListSettingsViewModelMapper()
        }
        
        dependenciesEngine.register(for: AliasListSettingsPresenterProtocol.self) { resolver in
            return AliasListSettingsPresenter(dependenciesResolver: resolver)
        }
    }
}
