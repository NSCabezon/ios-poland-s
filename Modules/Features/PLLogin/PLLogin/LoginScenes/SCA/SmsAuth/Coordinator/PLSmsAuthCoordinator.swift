//
//  PLSmsAuthCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase

final class PLSmsAuthCoordinator: ModuleCoordinator, PLScaAuthCoordinatorProtocol {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    lazy var deviceTrustDeviceDataCoordinator: PLDeviceDataCoordinator = {
        return PLDeviceDataCoordinator(dependenciesResolver: self.dependenciesEngine,
                                       navigationController: self.navigationController)
    }()

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLSmsAuthViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
/**
 #Register Scene depencencies.
*/
private extension PLSmsAuthCoordinator {
    func setupDependencies() {
        let presenter = PLSmsAuthPresenter(dependenciesResolver: self.dependenciesEngine)
        let authProcessUseCase = PLAuthProcessUseCase(dependenciesEngine: self.dependenciesEngine)
        let notificationGetTokenAndRegisterUseCase = PLGetNotificationTokenAndRegisterUseCase(dependenciesEngine: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLScaAuthCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLSmsAuthPresenterProtocol.self) { resolver in
            return presenter
        }

        self.dependenciesEngine.register(for: PLSmsAuthViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLSmsAuthViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLGetNotificationTokenAndRegisterUseCase.self) { resolver in
            return notificationGetTokenAndRegisterUseCase
        }

        self.dependenciesEngine.register(for: PLSmsAuthViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLSmsAuthPresenterProtocol.self)
            let viewController = PLSmsAuthViewController(
                nibName: "PLSmsAuthViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        
        self.dependenciesEngine.register(for: PLAuthenticateInitUseCase.self) { resolver in
           return PLAuthenticateInitUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLGetGlobalPositionOptionUseCase.self) { resolver in
            return PLGetGlobalPositionOptionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLAuthProcessUseCase.self) { _ in
            return authProcessUseCase
        }
        
        self.registerEnvironmentDependencies()
    }
}

extension PLSmsAuthCoordinator: PLLoginCoordinatorProtocol {}
extension PLSmsAuthCoordinator: LoginChangeEnvironmentResolverCapable {}
