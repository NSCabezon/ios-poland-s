//
//  RenameAliasCoordinator.swift
//  BLIK
//
//  Created by Piotr Mielcarzewicz on 13/09/2021.
//

import UI
import PLUI
import CoreFoundationLib
import CoreFoundationLib
import SANPLLibrary
import PLCommons

protocol RenameAliasCoordinatorProtocol: ModuleCoordinator {
    func goBackToAliasListAndRefreshIt()
    func goBack()
}

final class RenameAliasCoordinator: ModuleCoordinator {
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
        let presenter = RenameAliasPresenter(
            dependenciesResolver: dependenciesEngine,
            alias: alias
        )
        let controller = RenameAliasViewController(presenter: presenter)
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension RenameAliasCoordinator: RenameAliasCoordinatorProtocol {
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

private extension RenameAliasCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: RenameAliasCoordinatorProtocol.self) { resolver in
            return self
        }
        
        dependenciesEngine.register(for: ConfirmationDialogProducing.self) { resolver in
            return ConfirmationDialogFactory()
        }
        
        dependenciesEngine.register(for: RegisterAliasParametersMapping.self) { resolver in
            return RegisterAliasParametersMapper(
                dateFormatter: PLTimeFormat.YYYYMMDD_HHmmssSSS.createDateFormatter()
            )
        }
        
        dependenciesEngine.register(for: UpdateAliasUseCaseProtocol.self) { resolver in
            return UpdateAliasUseCase(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: BlikAliasNewLabelMapping.self) { resolver in
            return BlikAliasNewLabelMapper()
        }
        
        dependenciesEngine.register(for: AliasNameValidatorProtocol.self) { _ in
            return AliasNameValidator()
        }
    }
}


