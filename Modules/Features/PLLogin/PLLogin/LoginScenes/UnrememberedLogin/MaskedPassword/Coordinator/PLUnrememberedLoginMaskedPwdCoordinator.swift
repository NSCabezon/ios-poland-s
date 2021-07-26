//
//  PLUnrememberedLoginMaskedPwdCoordinator.swift
//  PLLogin

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase

protocol PLUnrememberedLoginMaskedPwdCoordinatorProtocol {
    func goToSMSScene()
    func goToSofwareTokenScene()
    func goToHardwareTokenScene()
}

final class PLUnrememberedLoginMaskedPwdCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let smsAuthCoordinator: PLSmsAuthCoordinator
    private lazy var loginLayerManager: PLLoginLayersManager = {
        return PLLoginLayersManager(dependenciesResolver: self.dependenciesEngine)
    }()

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.smsAuthCoordinator = PLSmsAuthCoordinator(
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
        // TODO: start hardware token coordinator
    }
    
    func goToSofwareTokenScene() {
        // TODO: start software token coordinator
    }
    
    func goToSMSScene() {
        self.smsAuthCoordinator.start()
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

        self.dependenciesEngine.register(for: PLLoginPresenterLayerProtocol.self) { _ in
            return presenter
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
            presenter.loginManager = self.loginLayerManager
            return viewController
        }
    }
}

extension PLUnrememberedLoginMaskedPwdCoordinator: PLLoginCoordinatorProtocol {
    // TODO: override navigation methods if necessary
}
