//
//  PLTrustedDeviceHardwareTokenCoordinator.swift
//  PLLogin
//

import UI
import Models
import Commons


protocol PLTrustedDeviceHardwareTokenCoordinatorProtocol {
    func goToDeviceTrustDeviceData()
}

final class PLTrustedDeviceHardwareTokenCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLTrustedDeviceHardwareTokenViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLTrustedDeviceHardwareTokenCoordinator: PLTrustedDeviceHardwareTokenCoordinatorProtocol {

    func goToDeviceTrustDeviceData() {
        guard let viewController = self.navigationController?.viewControllers.first(where: { vController in
            vController is PLDeviceDataViewController
        }) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.navigationController?.popToViewController(viewController, animated: true)
    }
}

/**
 Register Scene depencencies.
*/
private extension PLTrustedDeviceHardwareTokenCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLTrustedDeviceHardwareTokenCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceHardwareTokenPresenterProtocol.self) { resolver in
            return PLTrustedDeviceHardwareTokenPresenter(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLTrustedDeviceHardwareTokenViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLTrustedDeviceHardwareTokenPresenterProtocol.self)
            let viewController = PLTrustedDeviceHardwareTokenViewController(
                nibName: "PLTrustedDeviceHardwareTokenViewController",
                bundle: .module,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}
