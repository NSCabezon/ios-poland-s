import Commons
import UI
import Models
import LoginCommon

public protocol PLLoginMainModuleCoordinatorDelegate: class {
    //TODO: add implementations
}

public class PLLoginMainModuleCoordinator: ModuleSectionedCoordinator {
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    
    public init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: PLLoginViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func setupDependencies() {
    
        self.dependenciesEngine.register(for: PLLoginPresenterProtocol.self) { dependenciesResolver in
            return PLLoginPresenter(dependenciesResolver: dependenciesResolver)
        }
        
        self.dependenciesEngine.register(for: PLLoginViewProtocol.self) { dependenciesResolver in
            return dependenciesResolver.resolve(for: PLLoginViewController.self)
        }
        
        self.dependenciesEngine.register(for: PLLoginViewController.self) { dependenciesResolver in
            var presenter: PLLoginPresenterProtocol = dependenciesResolver.resolve(for: PLLoginPresenterProtocol.self)
            let viewController = PLLoginViewController(nibName: "PLLogin", bundle: Bundle.module, presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}

extension PLLoginMainModuleCoordinator: LoginModuleCoordinatorProtocol {
    public func start(_ section: LoginSection) {
//        switch section {
//        case .unrememberedLogin:
//            return self.coordinator.start()
//        case .loginRemembered:
//            return self.coordinatorRemembered.start()
//        case .quickBalance:
//            break
//        }
    }
}