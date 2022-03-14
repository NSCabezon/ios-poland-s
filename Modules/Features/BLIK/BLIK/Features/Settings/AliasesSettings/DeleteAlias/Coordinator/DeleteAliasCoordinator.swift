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

enum DeleteAliasCoordinatorEntryPoint {
    case aliasList
    case blikTransaction
}

protocol DeleteAliasCoordinatorProtocol: ModuleCoordinator {
    func goBackAfterAliasDeletion()
    func goBack()
}

final class DeleteAliasCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let alias: BlikAlias
    private let entryPoint: DeleteAliasCoordinatorEntryPoint

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        alias: BlikAlias,
        entryPoint: DeleteAliasCoordinatorEntryPoint
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.alias = alias
        self.entryPoint = entryPoint
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
    func goBackAfterAliasDeletion() {
        switch entryPoint {
        case .aliasList:
            goBackToAliasListAndRefreshIt()
        case .blikTransaction:
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func goBackToAliasListAndRefreshIt() {
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


