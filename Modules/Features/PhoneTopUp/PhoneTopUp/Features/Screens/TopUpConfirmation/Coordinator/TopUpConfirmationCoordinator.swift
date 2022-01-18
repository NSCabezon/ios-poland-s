//
//  TopUpConfirmationCoordinator.swift
//  PhoneTopUp
//
//  Created by 188216 on 13/01/2022.
//

import Commons
import Foundation
import UI

protocol TopUpConfirmationCoordinatorProtocol: AnyObject, ModuleCoordinator {
    func back()
    func close()
}

final class TopUpConfirmationCoordinator: TopUpConfirmationCoordinatorProtocol {
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
        self.dependenciesEngine.register(for: TopUpConfirmationCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: TopUpConfirmationPresenterProtocol.self) { resolver in
            return TopUpConfirmationPresenter(dependenciesResolver: resolver, summary: summary)
        }

        self.dependenciesEngine.register(for: TopUpConfirmationViewController.self) { resolver in
            let presenter = resolver.resolve(for: TopUpConfirmationPresenterProtocol.self)
            let viewController = TopUpConfirmationViewController(
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    // MARK: Methods
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: TopUpConfirmationViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func close() {
        navigationController?.popToRootViewController(animated: true)
    }
}
