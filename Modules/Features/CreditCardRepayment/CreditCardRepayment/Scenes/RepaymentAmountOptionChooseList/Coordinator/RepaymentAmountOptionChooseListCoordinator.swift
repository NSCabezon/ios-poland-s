//
//  RepaymentAmountOptionChooseListCoordinator.swift
//  Pods
//
//  Created by 186484 on 07/06/2021.
//  

import UI
import Models
import Commons

/**
    #Add method that must be handle by the RepaymantChooseListCoordinator like 
    navigation between the module scene and so on.
*/
protocol RepaymentAmountOptionChooseListCoordinatorProtocol: ModuleCoordinator {
    var onCloseConfirmed: (() -> Void)? { get set }
    func goBack()
}

final class RepaymentAmountOptionChooseListCoordinator: RepaymentAmountOptionChooseListCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    var onCloseConfirmed: (() -> Void)?

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: RepaymentAmountOptionChooseListViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension RepaymentAmountOptionChooseListCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: RepaymentAmountOptionChooseListCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: RepaymentAmountOptionChooseListPresenterProtocol.self) { resolver in
            return RepaymentAmountOptionChooseListPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetCreditCardRepaymentAmountOptionsUseCase.self) { resolver in
            return GetCreditCardRepaymentAmountOptionsUseCase(dependenciesResolver: resolver)
        }
         
        self.dependenciesEngine.register(for: RepaymentAmountOptionChooseListViewController.self) { resolver in
            var presenter = resolver.resolve(for: RepaymentAmountOptionChooseListPresenterProtocol.self)
            let viewController = RepaymentAmountOptionChooseListViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}
