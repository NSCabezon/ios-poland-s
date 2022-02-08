//
//  PLRememberedLoginPinCoordinator.swift
//  PLLogin
//
//  Created by Mario Rosales Maillo on 30/9/21.
//

import CoreFoundationLib
import SANLegacyLibrary
import LoginCommon
import CoreDomain
import PLCommons
import Commons
import UI

protocol PLRememberedLoginPinCoordinatorProtocol: PLLoginCoordinatorProtocol {
    func loadUnrememberedLogin()
}

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
    func loadUnrememberedLogin() {
        let loginModuleCoordinator = self.dependenciesEngine.resolve(for: PLLoginModuleCoordinatorProtocol.self)
        loginModuleCoordinator.loadUnrememberedLogin()
    }
}

// MARK: Register Scene depencencies.
private extension PLRememberedLoginPinCoordinator {
    func setupDependencies() {
        
        let presenter = PLRememberedLoginPinPresenter(dependenciesResolver: self.dependenciesEngine,
                                                      configuration: self.loginConfiguration)

        let notificationTokenRegisterProcessGroup = PLNotificationTokenRegisterProcessGroup(dependenciesEngine: self.dependenciesEngine)

        let rememeberedLoginProcessGroup = PLRememberedLoginProcessGroup(dependenciesEngine: self.dependenciesEngine)

        let openSessionProcessGroup = PLOpenSessionProcessGroup(dependenciesEngine: self.dependenciesEngine)
        
        self.dependenciesEngine.register(for: PLRememberedLoginPinPresenterProtocol.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLRememberedLoginPinViewControllerProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLRememberedLoginPinViewController.self)
        }

        self.dependenciesEngine.register(for: PLNotificationTokenRegisterProcessGroup.self) { resolver in
            return notificationTokenRegisterProcessGroup
        }
        
        self.dependenciesEngine.register(for: PLLoginPullOfferLoader.self) { _ in
            return PLLoginPullOfferLoader(dependenciesEngine: self.dependenciesEngine)
        }
        
        self.dependenciesEngine.register(for: PLRememberedLoginPinCoordinator.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLOpenSessionProcessGroup.self) { resolver in
            return openSessionProcessGroup
        }

        self.dependenciesEngine.register(for: PLRememberedLoginProcessGroup.self) { resolver in
           return rememeberedLoginProcessGroup
        }
        
        self.dependenciesEngine.register(for: PLRememberedLoginChangeUserUseCase.self) { resolver in
            return PLRememberedLoginChangeUserUseCase(dependenciesResolver: resolver)
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
