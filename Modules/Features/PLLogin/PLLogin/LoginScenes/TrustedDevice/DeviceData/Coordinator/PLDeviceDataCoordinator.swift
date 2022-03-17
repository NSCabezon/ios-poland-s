//
//  PLDeviceDataCoordinator.swift
//  PLLogin
//
//  Created by Juan Sánchez Marín on 16/6/21.
//

import CoreFoundationLib
import UI

protocol PLDeviceDataCoordinatorProtocol {
    func goToTrustedDevicePIN(with trustedDeviceConfiguration: TrustedDeviceConfiguration)
    func presentTermsAndConditions(configuration: PLTermsAndConditionsConfiguration)
}

final class PLDeviceDataCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private lazy var trustedDevicePinCoordinator: PLTrustedDevicePinCoordinator = {
        return PLTrustedDevicePinCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            navigationController: self.navigationController
        )
    }()
    
    private lazy var termsAndConditionsCoordinator: PLTermsAndConditionsCoordinatorProtocol = {
        return PLTermsAndConditionsCoordinator(dependenciesResolver: self.dependenciesEngine,
                                               delegate: self,
                                               navigationController: navigationController)
    }()

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLDeviceDataViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLDeviceDataCoordinator: PLDeviceDataCoordinatorProtocol {
    
    func presentTermsAndConditions(configuration: PLTermsAndConditionsConfiguration) {
        self.termsAndConditionsCoordinator.startWith(configuration: configuration)
    }
    
    func goToTrustedDevicePIN(with trustedDeviceConfiguration: TrustedDeviceConfiguration) {
        self.dependenciesEngine.register(for: TrustedDeviceConfiguration.self) { _ in
            return trustedDeviceConfiguration
        }
        self.trustedDevicePinCoordinator.start()
    }
}

extension PLDeviceDataCoordinator: PLTermsAndConditionsCoordinatorDelegate {
    
    func onAcceptTerms() {
        let presenter = self.dependenciesEngine.resolve(for: PLDeviceDataPresenterProtocol.self)
        presenter.enableContinueButton()
    }
    
    func onRejectTerms() {
        let loginModuleCoordinator = self.dependenciesEngine.resolve(for: PLLoginModuleCoordinatorProtocol.self)
        loginModuleCoordinator.loadUnrememberedLogin()
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
        self.dependenciesEngine.register(for: PLStoreSecIdentityUseCase.self) { resolver in
           return PLStoreSecIdentityUseCase()
        }
        self.dependenciesEngine.register(for: PLDeviceDataRegisterDeviceUseCase.self) { resolver in
           return PLDeviceDataRegisterDeviceUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: PLDeviceDataGenerateDataUseCase.self) { resolver in
           return PLDeviceDataGenerateDataUseCase(dependenciesResolver: resolver)
        }
    }
}

extension PLDeviceDataCoordinator: PLLoginCoordinatorProtocol {}
extension PLDeviceDataCoordinator: LoginChangeEnvironmentResolverCapable {}
