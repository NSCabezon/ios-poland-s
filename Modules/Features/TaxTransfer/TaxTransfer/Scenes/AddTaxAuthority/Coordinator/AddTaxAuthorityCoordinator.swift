//
//  AddTaxAuthorityCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import CoreFoundationLib
import UI

enum AddTaxAuthorityEntryPointContext {
    case didSelectTaxAuthorityInTransferForm(TaxAuthority)
    case didSelectTaxAuthorityInPredefinedList(TaxAuthority)
    case didNotPreselectAnyData
}

protocol AddTaxAuthorityCoordinatorProtocol: ModuleCoordinator {
    func back()
    func close()
}

final class AddTaxAuthorityCoordinator: AddTaxAuthorityCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let entryPointContext: AddTaxAuthorityEntryPointContext

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        entryPointContext: AddTaxAuthorityEntryPointContext
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.entryPointContext = entryPointContext
        setUpDependencies()
    }
    
    func start() {
        let controller = dependenciesEngine.resolve(for: AddTaxAuthorityViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension AddTaxAuthorityCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: AddTaxAuthorityCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: AddTaxAuthorityViewModelMapping.self) { _ in
            return AddTaxAuthorityViewModelMapper()
        }
        
        dependenciesEngine.register(for: AddTaxAuthorityPresenterProtocol.self) { resolver in
            // TODO:- Configure presenter with entry point context (TAP-2649)
            return AddTaxAuthorityPresenter(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: AddTaxAuthorityViewController.self) { resolver in
            var presenter = resolver.resolve(for: AddTaxAuthorityPresenterProtocol.self)
            let controller = AddTaxAuthorityViewController(presenter: presenter)
            presenter.view = controller
            return controller
        }
    }
}
