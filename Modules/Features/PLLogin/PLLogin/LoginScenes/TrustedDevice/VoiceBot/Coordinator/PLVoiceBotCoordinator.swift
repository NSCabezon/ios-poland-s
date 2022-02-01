//
//  VoiceBotCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 29/7/21.
//

import UI
import CoreFoundationLib
import CoreFoundationLib

protocol PLVoiceBotCoordinatorProtocol {
    func goToHardwareToken()
    func goToSmsAuth()
    func goBack()
}

final class PLVoiceBotCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private var trustedSmsAuthCoordinator: PLTrustedDeviceSmsAuthCoordinator?
    private var hardwareTokenCoordinator: PLTrustedDeviceHardwareTokenCoordinator?

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLVoiceBotViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLVoiceBotCoordinator: PLVoiceBotCoordinatorProtocol {
    func goBack() {
        guard let viewController = self.navigationController?.viewControllers.first(where: { vController in
            vController is PLDeviceDataViewController
        }) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.navigationController?.popToViewController(viewController, animated: true)
    }
    
    func goToHardwareToken() {
        self.hardwareTokenCoordinator = PLTrustedDeviceHardwareTokenCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            trustedDeviceConfiguration: self.dependenciesEngine.resolve(for: TrustedDeviceConfiguration.self),
            loginConfiguration: self.dependenciesEngine.resolve(for: UnrememberedLoginConfiguration.self),
            navigationController: navigationController)
        self.hardwareTokenCoordinator?.start()
    }
    
    func goToSmsAuth() {
        self.trustedSmsAuthCoordinator = PLTrustedDeviceSmsAuthCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            trustedDeviceConfiguration: self.dependenciesEngine.resolve(for: TrustedDeviceConfiguration.self),
            loginConfiguration: self.dependenciesEngine.resolve(for: UnrememberedLoginConfiguration.self),
            navigationController: navigationController)
        self.trustedSmsAuthCoordinator?.start()
    }
}

/**
 Register Scene depencencies.
*/
private extension PLVoiceBotCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: PLVoiceBotCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLVoiceBotPresenterProtocol.self) { resolver in
            return PLVoiceBotPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLIvrRegisterUseCase.self) { resolver in
            return PLIvrRegisterUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLDevicesUseCase.self) { resolver in
            return PLDevicesUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLVoiceBotViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLVoiceBotPresenterProtocol.self)
            let viewController = PLVoiceBotViewController(
                nibName: "PLVoiceBotViewController",
                bundle: .module,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

