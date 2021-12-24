//
//  PLTrustedDeviceHardwareTokenCoordinator.swift
//  PLLogin
//

import UI
import CoreFoundationLib
import Commons


protocol PLTrustedDeviceHardwareTokenCoordinatorProtocol {
    func goToDeviceTrustDeviceData()
    func goToTrustedDeviceSuccess()
}

final class PLTrustedDeviceHardwareTokenCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    internal let loginConfiguration: UnrememberedLoginConfiguration
    internal let trustedDeviceConfiguration: TrustedDeviceConfiguration
    private lazy var trustedDeviceCoordinator: PLTrustedDeviceSuccessCoordinator = {
        return PLTrustedDeviceSuccessCoordinator(dependenciesResolver: self.dependenciesEngine,
                                     navigationController: self.navigationController)
    }()

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
    
    func goToTrustedDeviceSuccess() {
        self.trustedDeviceCoordinator.start()
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
        
        self.dependenciesEngine.register(for: PLTrustedDeviceStoreHeadersUseCase.self) { resolver in
            return PLTrustedDeviceStoreHeadersUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLTrustedDeviceSecondFactorChallengeUseCase.self) { resolver in
            return PLTrustedDeviceSecondFactorChallengeUseCase()
        }
        
        self.dependenciesEngine.register(for: TrustedDeviceConfiguration.self) { _ in
            return self.trustedDeviceConfiguration
        }
        
        self.dependenciesEngine.register(for: UnrememberedLoginConfiguration.self) { _ in
            return self.loginConfiguration
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
