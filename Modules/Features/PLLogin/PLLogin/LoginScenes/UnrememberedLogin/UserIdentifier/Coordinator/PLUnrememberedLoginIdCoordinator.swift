//
//  PLUnrememberedLoginIdCoordinator.swift
//  PLLogin

import Commons
import UI
import Models
import SANLegacyLibrary
import LoginCommon
import CommonUseCase
import Commons
import DomainCommon

protocol PLUnrememberedLoginIdCoordinatorProtocol {
    func goToNormalPasswordScene(configuration: UnrememberedLoginConfiguration)
    func goToMaskedPasswordScene(configuration: UnrememberedLoginConfiguration)
}

final class PLUnrememberedLoginIdCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    internal let dependenciesEngine: DependenciesResolver & DependenciesInjector
    private let normalPwdCoordinator: PLUnrememberedLoginNormalPwdCoordinator
    private let maskedPwdCoordinator: PLUnrememberedLoginMaskedPwdCoordinator
    private lazy var loginLayerManager: PLLoginLayersManager = {
        return PLLoginLayersManager(dependenciesResolver: self.dependenciesEngine)
    }()

    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.normalPwdCoordinator = PLUnrememberedLoginNormalPwdCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            navigationController: navigationController
        )
        self.maskedPwdCoordinator = PLUnrememberedLoginMaskedPwdCoordinator(
            dependenciesResolver: self.dependenciesEngine,
            navigationController: navigationController
        )
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: PLUnrememberedLoginIdViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PLUnrememberedLoginIdCoordinator: PLUnrememberedLoginIdCoordinatorProtocol {
    func goToNormalPasswordScene(configuration: UnrememberedLoginConfiguration) {
        self.dependenciesEngine.register(for: UnrememberedLoginConfiguration.self) { _ in
            return configuration
        }
        self.normalPwdCoordinator.start()
    }
    
    func goToMaskedPasswordScene(configuration: UnrememberedLoginConfiguration) {
        self.dependenciesEngine.register(for: UnrememberedLoginConfiguration.self) { _ in
            return configuration
        }
        self.maskedPwdCoordinator.start()
    }
}


// MARK: Register Scene depencencies.
private extension PLUnrememberedLoginIdCoordinator {
    func setupDependencies() {
        let presenter = PLUnrememberedLoginIdPresenter(dependenciesResolver: self.dependenciesEngine)
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginIdCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: PLLoginPresenterLayerProtocol.self) { _ in
            return presenter
        }

        self.dependenciesEngine.register(for: PLLoginProcessLayerProtocol.self) { resolver in
            return PLLoginProcessLayer(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginIdPresenterProtocol.self) { resolver in
            return presenter
        }
        
        self.dependenciesEngine.register(for: PLUnrememberedLoginIdViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLUnrememberedLoginIdViewController.self)
        }

        self.dependenciesEngine.register(for: PLLoginCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: PLUnrememberedLoginIdViewController.self) { resolver in
            var presenter = resolver.resolve(for: PLUnrememberedLoginIdPresenterProtocol.self)
            let viewController = PLUnrememberedLoginIdViewController(
                nibName: "PLUnrememberedLoginIdViewController",
                bundle: Bundle.module,
                dependenciesResolver: resolver,
                presenter: presenter)
            presenter.view = viewController
            presenter.loginManager = self.loginLayerManager
            return viewController
        }

        self.dependenciesEngine.register(for: PLLoginUseCase.self) { resolver in
            return PLLoginUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLGetPublicKeyUseCase.self) { resolver in
            return PLGetPublicKeyUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLAuthenticateInitUseCase.self) { resolver in
            return PLAuthenticateInitUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: PLAuthenticateUseCase.self) { resolver in
            return PLAuthenticateUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: LoginPLPullOfferLayer.self) { resolver in
            return LoginPLPullOfferLayer(dependenciesResolver: resolver)
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
        self.registerEnvironmentDependencies()
    }
}

protocol LoginPLPullOfferLayerDelegate: class {
    func loadPullOffersSuccess()
}

final class LoginPLPullOfferLayer {
    private let dependenciesResolver: DependenciesResolver
    private weak var delegate: LoginPLPullOfferLayerDelegate?
    private var locations = [PullOfferLocation]()
    
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    private var pullOfferCandidatesUseCase: PullOfferCandidatesUseCase {
        return self.dependenciesResolver.resolve(for: PullOfferCandidatesUseCase.self)
    }
    
    lazy var loadPullOffersSuperUseCase: SetupPublicPullOffersSuperUseCase = {
        let superUseCase = self.dependenciesResolver.resolve(for: SetupPublicPullOffersSuperUseCase.self)
        superUseCase.delegate = self
        return superUseCase
    }()
    
    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
    
    func setDelegate(_ delegate: LoginPLPullOfferLayerDelegate) {
        self.delegate = delegate
    }
    
    func loadPullOffers() {
        self.loadPullOffersSuperUseCase.execute()
    }
}

extension LoginPLPullOfferLayer: SetupPublicPullOffersSuperUseCaseDelegate {
    func onSuccess() {
        self.delegate?.loadPullOffersSuccess()
    }
}

extension PLUnrememberedLoginIdCoordinator: PLLoginCoordinatorProtocol {}
extension PLUnrememberedLoginIdCoordinator: LoginChangeEnvironmentResolverCapable {}
