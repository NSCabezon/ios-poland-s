//
//  PLUnrememberedLoginMaskedPwdCoordinator.swift
//  PLLogin

import CoreFoundationLib
import UI
import SANLegacyLibrary
import LoginCommon

protocol PLUnrememberedLoginMaskedPwdCoordinatorProtocol {
    func goToSMSScene()
    func goToSofwareTokenScene()
    func goToHardwareTokenScene()
    func goBackToLogin()
}

final class PLUnrememberedLoginMaskedPwdCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let smsAuthCoordinator: PLSmsAuthCoordinator
    private let hardwareTokenCoordinator: PLHardwareTokenCoordinator

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.smsAuthCoordinator = PLSmsAuthCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            navigationController: navigationController
        )
        self.hardwareTokenCoordinator = PLHardwareTokenCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            navigationController: navigationController
        )
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLUnrememberedLoginMaskedPwdViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLUnrememberedLoginMaskedPwdCoordinator: PLUnrememberedLoginMaskedPwdCoordinatorProtocol {
    func goToHardwareTokenScene() {
        self.hardwareTokenCoordinator.start()
    }
    
    func goToSofwareTokenScene() {
        // TODO: start software token coordinator
    }
    
    func goToSMSScene() {
        self.smsAuthCoordinator.start()
    }
    
    func goBackToLogin() {
        self.backToLogin()
    }
}

/**
 #Register Scene depencencies.
*/
private extension PLUnrememberedLoginMaskedPwdCoordinator {
    func setupDependencies() {
        let presenter = PLUnrememberedLoginMaskedPwdPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLUnrememberedLoginMaskedPwdCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginMaskedPwdPresenterProtocol.self) { resolver in
            return presenter
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginMaskedPwdViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLUnrememberedLoginMaskedPwdViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginMaskedPwdViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLUnrememberedLoginMaskedPwdPresenterProtocol.self)
            let viewController = PLUnrememberedLoginMaskedPwdViewController(
                nibName: "PLUnrememberedLoginMaskedPwdViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension PLUnrememberedLoginMaskedPwdCoordinator: PLLoginCoordinatorProtocol {
    // TODO: override navigation methods if necessary
}
