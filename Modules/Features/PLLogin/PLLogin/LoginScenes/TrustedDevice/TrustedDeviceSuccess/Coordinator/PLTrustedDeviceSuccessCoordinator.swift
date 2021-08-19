//
//  PLTrustedDeviceSuccessCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 13/8/21.
//

import UI
import Models
import Commons

protocol PLTrustedDeviceSuccessCoordinatorProtocol {
}

final class PLTrustedDeviceSuccessCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLTrustedDeviceSuccessViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLTrustedDeviceSuccessCoordinator: PLTrustedDeviceSuccessCoordinatorProtocol {
}

/**
 Register Scene depencencies.
*/
private extension PLTrustedDeviceSuccessCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLTrustedDeviceSuccessCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceSuccessPresenterProtocol.self) { resolver in
            return PLTrustedDeviceSuccessPresenter(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceSuccessViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLTrustedDeviceSuccessPresenterProtocol.self)
            let viewController = PLTrustedDeviceSuccessViewController(
                nibName: "PLTrustedDeviceSuccessViewController",
                bundle: .module,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

