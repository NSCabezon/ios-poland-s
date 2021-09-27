import UI
import Commons
import LoginCommon

public class PLLoginModuleCoordinator: ModuleSectionedCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let unrememberdLoginIdCoordinator: PLUnrememberedLoginIdCoordinator
    private lazy var unrememberedLoginOnboardingCoordinator: PLUnrememberedLoginOnboardingCoordinator = {
        return PLUnrememberedLoginOnboardingCoordinator(dependenciesResolver: self.dependenciesEngine, navigationController: self.navigationController)
    }()
    
    private lazy var isFirstLaunchUseCase: PLFirstLaunchUseCase = {
        return PLFirstLaunchUseCase(dependenciesResolver: dependenciesEngine)
    }()

    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.unrememberdLoginIdCoordinator = PLUnrememberedLoginIdCoordinator(dependenciesResolver: dependenciesEngine, navigationController: navigationController)
    }
}

extension PLLoginModuleCoordinator: LoginModuleCoordinatorProtocol {
    public func start(_ section: LoginSection) {
        switch section {
        case .unrememberedLogin:
            Scenario(useCase: self.isFirstLaunchUseCase, input: PLFirstLaunchUseCaseInput(shouldSetFirstLaunch: false))
                .execute(on: self.dependenciesEngine.resolve())
                .onSuccess { result in
                    if result.isFirstLaunch {
                        return self.unrememberedLoginOnboardingCoordinator.start()
                    } else {
                        return self.unrememberdLoginIdCoordinator.start()
                    }
                }
        case .loginRemembered:
            break
        case .quickBalance:
            break
        }
    }
}
