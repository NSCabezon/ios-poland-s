import UI
import Commons
import LoginCommon

public protocol PLLoginModuleCoordinatorProtocol: AnyObject {
    func loadUnrememberedLogin()
    func loadRememberedLogin(configuration: RememberedLoginConfiguration)
}

public class PLLoginModuleCoordinator: ModuleSectionedCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    private lazy var unrememberdLoginIdCoordinator: PLUnrememberedLoginIdCoordinator = {
        return PLUnrememberedLoginIdCoordinator(dependenciesResolver: dependenciesEngine, navigationController: navigationController)
    }()
    
    private lazy var rememberedLoginPinCoordinator: PLRememberedLoginPinCoordinator = {
        return PLRememberedLoginPinCoordinator(dependenciesResolver: dependenciesEngine, navigationController: navigationController)
    }()
    
    
    private lazy var unrememberedLoginOnboardingCoordinator: PLUnrememberedLoginOnboardingCoordinator = {
        return PLUnrememberedLoginOnboardingCoordinator(dependenciesResolver: self.dependenciesEngine, navigationController: self.navigationController)
    }()
    
    private lazy var beforeLoginCoordinator: PLBeforeLoginCoordinator = {
        return PLBeforeLoginCoordinator(dependenciesResolver: self.dependenciesEngine,
                                        navigationController: self.navigationController)
    }()
    
    private lazy var isFirstLaunchUseCase: PLFirstLaunchUseCase = {
        return PLFirstLaunchUseCase(dependenciesResolver: dependenciesEngine)
    }()

    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        
        self.dependenciesEngine.register(for: PLLoginModuleCoordinatorProtocol.self) { resolver in
            return self
        }
    }
}

extension PLLoginModuleCoordinator: LoginModuleCoordinatorProtocol {
    
    public func start(_ section: LoginSection) {
        self.beforeLoginCoordinator.start()
    }
}

extension PLLoginModuleCoordinator : PLLoginModuleCoordinatorProtocol {
    
    public func loadUnrememberedLogin() {
        //checkFirstLaunch() SHOW ONBOARDING ONLY THE FIRST TIME
        self.unrememberedLoginOnboardingCoordinator.start()
    }
    
    public func loadRememberedLogin(configuration: RememberedLoginConfiguration) {
        self.dependenciesEngine.register(for: RememberedLoginConfiguration.self) { _ in
            return configuration
        }
        self.rememberedLoginPinCoordinator.start()
    }
}

/*private extension PLLoginModuleCoordinator {
    func checkFirstLaunch() {
        Scenario(useCase: self.isFirstLaunchUseCase, input: PLFirstLaunchUseCaseInput(shouldSetFirstLaunch: false))
            .execute(on: self.dependenciesEngine.resolve())
            .onSuccess { result in
                if result.isFirstLaunch {
                    self.unrememberedLoginOnboardingCoordinator.start()
                } else {
                    self.unrememberdLoginIdCoordinator.start()
                }
            }
    }
}*/
