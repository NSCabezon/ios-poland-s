//
//  PLDeviceDataController.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 16/6/21.
//

import Commons
import UI
import Models
import CommonUseCase

protocol PLDeviceDataCoordinatorProtocol {
    func goToTrustedDevicePIN(with trustedDeviceConfiguration: TrustedDeviceConfiguration)
}

final class PLDeviceDataCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let trustedDevicePinCoordinator: PLTrustedDevicePinCoordinator
    private lazy var loginLayerManager: PLLoginLayersManager = {
        return PLLoginLayersManager(dependenciesResolver: self.dependenciesEngine)
    }()

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.trustedDevicePinCoordinator = PLTrustedDevicePinCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            navigationController: navigationController
        )
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLDeviceDataViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLDeviceDataCoordinator: PLDeviceDataCoordinatorProtocol {
    func goToTrustedDevicePIN(with trustedDeviceConfiguration: TrustedDeviceConfiguration) {
        self.dependenciesEngine.register(for: TrustedDeviceConfiguration.self) { _ in
            return trustedDeviceConfiguration
        }
        self.trustedDevicePinCoordinator.start()
    }
}

/**
 #Register Scene depencencies.
*/
private extension PLDeviceDataCoordinator {
    func setupDependencies() {
        let presenter = PLDeviceDataPresenter(dependenciesResolver: self.dependenciesEngine)

        self.dependenciesEngine.register(for: PLDeviceDataCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLDeviceDataPresenterProtocol.self) { resolver in
            return presenter
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLDeviceDataViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLDeviceDataPresenterProtocol.self)
            let viewController = PLDeviceDataViewController(
                nibName: "PLDeviceDataViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            return viewController
        }

        self.dependenciesEngine.register(for: PLDeviceDataTransportKeyEncryptionUseCase.self) { resolver in
           return PLDeviceDataTransportKeyEncryptionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLDeviceDataParametersEncryptionUseCase.self) { resolver in
           return PLDeviceDataParametersEncryptionUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLDeviceDataCertificateCreationUseCase.self) { resolver in
           return PLDeviceDataCertificateCreationUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLDeviceDataRegisterDeviceUseCase.self) { resolver in
           return PLDeviceDataRegisterDeviceUseCase(dependenciesResolver: resolver)
        }
    }
}

extension PLDeviceDataCoordinator: PLLoginCoordinatorProtocol {}
extension PLDeviceDataCoordinator: LoginChangeEnvironmentResolverCapable {}
