//
//  AccountChooseListCoordinator.swift
//  Pods
//
//  Created by 186484 on 04/06/2021.
//  

import UI
import CoreFoundationLib

/**
    #Add method that must be handle by the AccountChooseListCoordinator like 
    navigation between the module scene and so on.
*/
protocol AccountChooseListCoordinatorProtocol: ModuleCoordinator {
    var onCloseConfirmed: (() -> Void)? { get set }
    func goBack()
}

final class AccountChooseListCoordinator: AccountChooseListCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    var onCloseConfirmed: (() -> Void)?

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: AccountChooseListViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension AccountChooseListCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: AccountChooseListCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: AccountChooseListPresenterProtocol.self) { resolver in
            return AccountChooseListPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetAccountsUseCase.self) { resolver in
            return GetAccountsUseCase(dependenciesResolver: resolver)
        }
         
        self.dependenciesEngine.register(for: AccountChooseListViewController.self) { resolver in
            var presenter = resolver.resolve(for: AccountChooseListPresenterProtocol.self)
            let viewController = AccountChooseListViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}
