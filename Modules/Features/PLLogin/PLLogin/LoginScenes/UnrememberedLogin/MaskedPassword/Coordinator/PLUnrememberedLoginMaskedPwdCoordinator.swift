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
}

final class PLUnrememberedLoginMaskedPwdCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
//    private let smsCoordinator: PLUnrememberedLoginSMSCoordinator
    private lazy var loginLayerManager: PLLoginLayersManager = {
        return PLLoginLayersManager(dependenciesResolver: self.dependenciesEngine)
    }()

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
//        self.smsCoordinator = PLUnrememberedLoginSMSCoordinator(
//            dependenciesResolver: self.dependenciesEngine,
//            navigationController: navigationController
//        )
        self.setupDependencies()
    }

    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLUnrememberedLoginMaskedPwdViewController.self)
        self.navigationController?.pushViewController(controller, animated: false)
    }
}

extension PLUnrememberedLoginMaskedPwdCoordinator: PLUnrememberedLoginMaskedPwdCoordinatorProtocol {
    func goToSMSScene() {
        // TODO
//        self.smsCoordinator.start()
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

        self.dependenciesEngine.register(for: PullOfferCandidatesUseCase.self) { resolver in
           return PullOfferCandidatesUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SetupPublicPullOffersSuperUseCase.self) { resolver in
           return SetupPublicPullOffersSuperUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: SetupPullOffersUseCase.self) { resolver in
           return SetupPullOffersUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: LoadPublicPullOffersVarsUseCase.self) { resolver in
           return LoadPublicPullOffersVarsUseCase(dependenciesResolver: resolver)
        }
        self.dependenciesEngine.register(for: CalculateLocationsUseCase.self) { resolver in
           return CalculateLocationsUseCase(dependenciesResolver: resolver)
        }
    }
}

extension PLUnrememberedLoginMaskedPwdCoordinator: PLLoginCoordinatorProtocol {
    // TODO: override navigation methods if necessary
}
