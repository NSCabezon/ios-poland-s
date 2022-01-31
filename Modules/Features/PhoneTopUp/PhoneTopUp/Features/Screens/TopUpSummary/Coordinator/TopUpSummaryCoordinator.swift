//
//  TopUpSummaryCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 17/01/2022.
//

import Commons
import Foundation
import UI

protocol TopUpSummaryCoordinatorProtocol: AnyObject, ModuleCoordinator {
    func close()
    func goToGlobalPosition()
    func makeAnotherTopUp()
}

final class TopUpSummaryCoordinator: TopUpSummaryCoordinatorProtocol {
    // MARK: Properties
    
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    // MARK: Lifecycle
    
    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         summary: TopUpModel) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies(with: summary)
    }
    
    // MARK: SetUp
    
    private func setupDependencies(with summary: TopUpModel) {
        self.dependenciesEngine.register(for: TopUpSummaryMapping.self) { _ in
            return TopUpSummaryMapper()
        }

        self.dependenciesEngine.register(for: TopUpSummaryCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: TopUpSummaryPresenterProtocol.self) { resolver in
            return TopUpSummaryPresenter(dependenciesResolver: resolver, summary: summary)
        }

        self.dependenciesEngine.register(for: TopUpSummaryViewController.self) { resolver in
            let presenter = resolver.resolve(for: TopUpSummaryPresenterProtocol.self)
            let viewController = TopUpSummaryViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    // MARK: Methods
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: TopUpSummaryViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func makeAnotherTopUp() {
        if let topupController = navigationController?.viewControllers.first(where: { $0 is PhoneTopUpFormViewController }) {
            navigationController?.popToViewController(topupController, animated: true)
            return
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
}
