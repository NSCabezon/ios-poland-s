//
//  PLUnrememberedLoginNormalPwdCoordinator.swift
//  PLLogin

import CoreFoundationLib
import UI
import CoreFoundationLib
import SANLegacyLibrary
import LoginCommon
import CoreFoundationLib

protocol PLUnrememberedLoginNormalPwdCoordinatorProtocol {
    func goToSMSScene()
    func goToSofwareTokenScene()
    func goToHardwareTokenScene()
    func goBackToLogin()
}

final class PLUnrememberedLoginNormalPwdCoordinator: ModuleCoordinator {
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
        let controller = self.dependenciesEngine.resolve(for: PLUnrememberedLoginNormalPwdViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLUnrememberedLoginNormalPwdCoordinator: PLUnrememberedLoginNormalPwdCoordinatorProtocol {
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
private extension PLUnrememberedLoginNormalPwdCoordinator {
    func setupDependencies() {
        let presenter = PLUnrememberedLoginNormalPwdPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLUnrememberedLoginNormalPwdCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginNormalPwdPresenterProtocol.self) { resolver in
            return presenter
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginNormalPwdViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLUnrememberedLoginNormalPwdViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginNormalPwdViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLUnrememberedLoginNormalPwdPresenterProtocol.self)
            let viewController = PLUnrememberedLoginNormalPwdViewController(
                nibName: "PLUnrememberedLoginNormalPwdViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension PLUnrememberedLoginNormalPwdCoordinator: PLLoginCoordinatorProtocol {
    // TODO: override navigation methods if necessary
}
