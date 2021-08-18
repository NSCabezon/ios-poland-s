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
    func goBack()
}

final class PLTrustedDeviceSmsAuthCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    internal let trustedDeviceConfiguration: TrustedDeviceConfiguration
    internal let loginConfiguration: UnrememberedLoginConfiguration

    init(dependenciesResolver: DependenciesResolver,
         trustedDeviceConfiguration: TrustedDeviceConfiguration,
         loginConfiguration: UnrememberedLoginConfiguration,
         navigationController: UINavigationController?) {
        
        self.navigationController = navigationController
        self.trustedDeviceConfiguration = trustedDeviceConfiguration
        self.loginConfiguration = loginConfiguration
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
        
        self.dependenciesEngine.register(for: PLTrustedDeviceSmsAuthCoordinatorProtocol.self) { _ in
            return self
        }
        
        let presenter = PLTrustedDeviceSmsAuthPresenter(dependenciesResolver: self.dependenciesEngine)
        self.dependenciesEngine.register(for: PLTrustedDeviceSmsAuthPresenterProtocol.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: TrustedDeviceConfiguration.self) { _ in
            return self.trustedDeviceConfiguration
        }
        
        self.dependenciesEngine.register(for: UnrememberedLoginConfiguration.self) { _ in
            return self.loginConfiguration
        }
        
        self.dependenciesEngine.register(for: PLConfirmationCodeRegisterUseCase.self) { resolver in
            return PLConfirmationCodeRegisterUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceStoreHeadersUseCase.self) { resolver in
            return PLTrustedDeviceStoreHeadersUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceSecondFactorChallengeUseCase.self) { resolver in
            return PLTrustedDeviceSecondFactorChallengeUseCase()
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

extension PLTrustedDeviceSmsAuthCoordinator : PLTrustedDeviceSmsAuthCoordinatorProtocol {
    
    func goBack() {
        guard let viewController = self.navigationController?.viewControllers.first(where: { vController in
            vController is PLDeviceDataViewController
        }) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.navigationController?.popToViewController(viewController, animated: true)
    }
}
