//
//  PLRememberedLoginPinCoordinator.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/9/21.
//

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase
import Commons
import DomainCommon


protocol PLRememberedLoginPinCoordinatorProtocol: PLLoginCoordinatorProtocol {}

extension PLRememberedLoginPinCoordinatorProtocol {
    func goToGlobalPositionScene(_ option: GlobalPositionOptionEntity) {
        self.goToPrivate(option)
    }
}

final class PLRememberedLoginPinCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    
    public var loginConfiguration: RememberedLoginConfiguration {
        self.dependenciesEngine.resolve(for: RememberedLoginConfiguration.self)
    }

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLRememberedLoginPinViewController.self)
        self.navigationController?.setViewControllers([controller], animated: false)
    }
}

extension PLRememberedLoginPinCoordinator: PLRememberedLoginPinCoordinatorProtocol {

}

// MARK: Register Scene depencencies.
private extension PLRememberedLoginPinCoordinator {
    func setupDependencies() {
        
        let presenter = PLRememberedLoginPinPresenter(dependenciesResolver: self.dependenciesEngine,
                                                      configuration: self.loginConfiguration)
        let notificationGetTokenAndRegisterUseCase = PLGetNotificationTokenAndRegisterUseCase(dependenciesEngine: self.dependenciesEngine)
        
        let authProcessUseCase = PLRememberedLoginProcessUseCase(dependenciesEngine: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLRememberedLoginProcessUseCase.self) { _ in
            return authProcessUseCase
        }
        
        self.dependenciesEngine.register(for: PLRememberedLoginPinPresenterProtocol.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLRememberedLoginPinViewControllerProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLRememberedLoginPinViewController.self)
        }

        self.dependenciesEngine.register(for: PLGetSecIdentityUseCase.self) {_  in
            return PLGetSecIdentityUseCase()
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceGetStoredEncryptedUserKeyUseCase.self) { resolver in
            return PLTrustedDeviceGetStoredEncryptedUserKeyUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceGetHeadersUseCase.self) { resolver in
            return PLTrustedDeviceGetHeadersUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLLoginAuthorizationDataEncryptionUseCase.self) { resolver in
            return PLLoginAuthorizationDataEncryptionUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLSessionUseCase.self) { resolver in
            return PLSessionUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLGetGlobalPositionOptionUseCase.self) { resolver in
            return PLGetGlobalPositionOptionUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLGetNotificationTokenAndRegisterUseCase.self) { resolver in
            return notificationGetTokenAndRegisterUseCase
        }

        self.dependenciesEngine.register(for: PLRememberedLoginPinCoordinator.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLRememberedLoginPinViewController.self) { resolver in
            let viewController = PLRememberedLoginPinViewController(
                nibName: "PLRememberedLoginPinViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.loginConfiguration = self.loginConfiguration
            presenter.view = viewController
            return viewController
        }
        self.registerEnvironmentDependencies()
    }
}

extension PLRememberedLoginPinCoordinator: LoginChangeEnvironmentResolverCapable {}
