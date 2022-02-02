//
//  PLSmsAuthCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 28/5/21.
//

import CoreFoundationLib
import UI
import SANLegacyLibrary
import LoginCommon

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
        let authProcessGroup = PLAuthProcessGroup(dependenciesEngine: self.dependenciesEngine)
        let notificationTokenRegisterProcessGroup = PLNotificationTokenRegisterProcessGroup(dependenciesEngine: self.dependenciesEngine)
        let openSessionProcessGroup = PLOpenSessionProcessGroup(dependenciesEngine: self.dependenciesEngine)

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

        self.dependenciesEngine.register(for: PLNotificationRegisterUseCase.self) { resolver in
            return PLNotificationRegisterUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLNotificationTokenRegisterProcessGroup.self) { resolver in
            return notificationTokenRegisterProcessGroup
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

        self.dependenciesEngine.register(for: PLAuthProcessGroup.self) { resolver in
            return authProcessGroup
        }

        self.dependenciesEngine.register(for: PLOpenSessionProcessGroup.self) { resolver in
            return openSessionProcessGroup
        }
        
        self.registerEnvironmentDependencies()
    }
}

extension PLSmsAuthCoordinator: PLLoginCoordinatorProtocol {}
extension PLSmsAuthCoordinator: LoginChangeEnvironmentResolverCapable {}
