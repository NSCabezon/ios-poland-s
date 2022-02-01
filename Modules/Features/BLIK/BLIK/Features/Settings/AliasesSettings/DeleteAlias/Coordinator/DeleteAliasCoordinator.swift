//
//  DeleteAliasCoordinator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 07/09/2021.
//

import UI
import PLUI
import CoreFoundationLib
import SANPLLibrary
import PLCommons

protocol DeleteAliasCoordinatorProtocol: ModuleCoordinator {
    func goBackToAliasListAndRefreshIt()
    func goBack()
}

final class DeleteAliasCoordinator: ModuleCoordinator {
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
        let mapper = dependenciesEngine.resolve(for: DeleteAliasViewModelMapping.self)
        let presenter = DeleteAliasPresenter(
            alias: alias,
            dependenciesResolver: dependenciesEngine
        )
        let controller = DeleteAliasViewController(
            presenter: presenter,
            viewModel: mapper.map(alias)
        )
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension DeleteAliasCoordinator: DeleteAliasCoordinatorProtocol {
    func goBackToAliasListAndRefreshIt() {
        let aliasListController = navigationController?
            .viewControllers
            .first(where: { $0 is AliasListSettingsViewController })
        
        guard let controller = aliasListController as? AliasListSettingsViewController else {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        navigationController?.popToViewController(controller, animated: true)
        controller.reloadView()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private extension DeleteAliasCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: DeleteAliasCoordinatorProtocol.self) { resolver in
            return self
        }
        
        dependenciesEngine.register(for: DeleteAliasViewModelMapping.self) { resolver in
            return DeleteAliasViewModelMapper()
        }
        
        dependenciesEngine.register(for: DeleteAliasUseCaseProtocol.self) { resolver in
            return DeleteAliasUseCase(
                managersProvider: resolver.resolve(for: PLManagersProviderProtocol.self),
                requestMapper: DeleteBlikAliasParametersMapper()
            )
        }
    }
}


