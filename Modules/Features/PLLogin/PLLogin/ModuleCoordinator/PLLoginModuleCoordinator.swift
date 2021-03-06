import UI
import CoreFoundationLib
import LoginCommon

public protocol PLLoginModuleCoordinatorProtocol: AnyObject {
    func loadUnrememberedLogin()
    func loadUserLogin()
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
        self.unrememberedLoginOnboardingCoordinator.start()
    }
    
    public func loadUserLogin() {
        guard let controller = self.navigationController?.viewControllers
                .first(where: { $0 is PLUnrememberedLoginIdViewController })
        else { return }
        self.navigationController?.popToViewController(controller, animated: false)
    }
    
    public func loadRememberedLogin(configuration: RememberedLoginConfiguration) {
        self.dependenciesEngine.register(for: RememberedLoginConfiguration.self) { _ in
            return configuration
        }
        self.rememberedLoginPinCoordinator.start()
    }
}
