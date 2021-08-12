//
//  PLTrustedDeviceSmsAuthCoordinator.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 11/8/21.
//

import Models
import Commons
import UI

protocol PLTrustedDeviceSmsAuthCoordinatorProtocol {

}

final class PLTrustedDeviceSmsAuthCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }

    public func start() {
        let controller = self.dependenciesEngine.resolve(for: PLTrustedDeviceSmsAuthViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

/**
 #Register Scene depencencies.
*/
private extension PLTrustedDeviceSmsAuthCoordinator {
    func setupDependencies() {
        
        let presenter = PLTrustedDeviceSmsAuthPresenter(dependenciesResolver: self.dependenciesEngine)
        self.dependenciesEngine.register(for: PLTrustedDeviceSmsAuthPresenterProtocol.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLTrustedDeviceSmsAuthViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLTrustedDeviceSmsAuthPresenterProtocol.self)
            let viewController = PLTrustedDeviceSmsAuthViewController(
                nibName: "PLTrustedDeviceSmsAuthViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}
