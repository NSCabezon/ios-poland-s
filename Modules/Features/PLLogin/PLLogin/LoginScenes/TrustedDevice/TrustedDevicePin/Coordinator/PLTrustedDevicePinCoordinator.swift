//
//  PLTrustedDevicePinCoordinator.swift
//  PLLogin

import UI
import Models
import Commons


protocol PLTrustedDevicePinCoordinatorProtocol {
    func goToVoiceBotScene()
}

final class PLTrustedDevicePinCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLTrustedDevicePinViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLTrustedDevicePinCoordinator: PLTrustedDevicePinCoordinatorProtocol {
    func goToVoiceBotScene() {
        //TODO:
    }
}

/**
 Register Scene depencencies.
*/
private extension PLTrustedDevicePinCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLTrustedDevicePinCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: PLTrustedDevicePinPresenterProtocol.self) { resolver in
            return PLTrustedDevicePinPresenter(dependenciesResolver: resolver)
        }
         
        self.dependenciesEngine.register(for: PLTrustedDevicePinViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLTrustedDevicePinPresenterProtocol.self)
            let viewController = PLTrustedDevicePinViewController(
                nibName: "PLTrustedDevicePinViewController",
                bundle: .module,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}