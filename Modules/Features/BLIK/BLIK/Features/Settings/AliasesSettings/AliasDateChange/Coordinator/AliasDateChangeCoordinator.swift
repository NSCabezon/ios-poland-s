//
//  AliasDateChangeCoordinator.swift
//  BLIK
//
//  Created by 186491 on 18/09/2021.
//

import UI
import PLUI
import Models
import Commons
import SANPLLibrary
import PLCommons

protocol AliasDateChangeCoordinatorProtocol: ModuleCoordinator {
    func goBack()
}

final class AliasDateChangeCoordinator: ModuleCoordinator {
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
        let presenter = AliasDateChangePresenter(dependenciesResolver: dependenciesEngine, alias: alias)
        let controller = AliasDateChangeViewController(presenter: presenter, viewModel: AliasDateChangeViewModel())
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AliasDateChangeCoordinator: AliasDateChangeCoordinatorProtocol {
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private extension AliasDateChangeCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: AliasDateChangeCoordinatorProtocol.self) { resolver in
            return self
        }
        
        dependenciesEngine.register(for: RegisterAliasParametersMapping.self) { resolver in
            let dateFormatter = PLTimeFormat.YYYYMMDD_HHmmssSSS.createDateFormatter()
            return RegisterAliasParametersMapper(
                dateFormatter: dateFormatter
            )
        }
        
        dependenciesEngine.register(for: RegisterAliasUseCaseProtocol.self) { resolver in
            return RegisterAliasUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: BlikAliasNewDateMapping.self) { resolver in
            return BlikAliasNewDateMapper()
        }
    }
}
