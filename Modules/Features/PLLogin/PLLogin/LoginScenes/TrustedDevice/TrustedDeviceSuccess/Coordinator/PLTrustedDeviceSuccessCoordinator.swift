//
//  PLTrustedDeviceSuccessCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 13/8/21.
//

import UI
import Models
import Commons

protocol PLTrustedDeviceSuccessCoordinatorProtocol: PLLoginCoordinatorProtocol {
    func goToGlobalPositionScene(_ option: GlobalPositionOptionEntity)
}

final class PLTrustedDeviceSuccessCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector

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
    func goToGlobalPositionScene(_ option: GlobalPositionOptionEntity) {
        self.goToPrivate(option)
    }
}

/**
 Register Scene depencencies.
*/
private extension PLTrustedDeviceSuccessCoordinator {
    func setupDependencies() {
        let notificationGetTokenAndRegisterUseCase = PLGetNotificationTokenAndRegisterUseCase(dependenciesEngine: self.dependenciesEngine)
        self.dependenciesEngine.register(for: PLTrustedDeviceSuccessCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceSuccessPresenterProtocol.self) { resolver in
            return PLTrustedDeviceSuccessPresenter(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLGetNotificationTokenAndRegisterUseCase.self) { resolver in
            return notificationGetTokenAndRegisterUseCase
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
