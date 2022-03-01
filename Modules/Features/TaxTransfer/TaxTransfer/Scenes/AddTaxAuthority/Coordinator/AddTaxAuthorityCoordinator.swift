//
//  AddTaxAuthorityCoordinator.swift
//  TaxTransfer
//
//  Created by 185167 on 15/02/2022.
//

import CoreFoundationLib
import UI

protocol AddTaxAuthorityCoordinatorProtocol: ModuleCoordinator {
    func back()
    func close()
}

final class AddTaxAuthorityCoordinator: AddTaxAuthorityCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
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
        
        dependenciesEngine.register(for: AddTaxAuthorityPresenterProtocol.self) { resolver in
            return AddTaxAuthorityPresenter(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: AddTaxAuthorityViewController.self) { resolver in
            let presenter = resolver.resolve(for: AddTaxAuthorityPresenterProtocol.self)
            return AddTaxAuthorityViewController(presenter: presenter)
        }
    }
}
