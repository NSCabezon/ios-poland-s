import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons
import CoreDomain

public protocol AuthorizationModuleCoordinatorProtocol: ModuleCoordinator {
    func pop()
    func close()
    func showAuthorization(for challenge: ChallengeRepresentable)
    
    //TODO: - remove after beer
    func showEmptyAuthorization()
    func showOperationToConfirm()
}

public final class AuthorizationModuleCoordinator: AuthorizationModuleCoordinatorProtocol {
    
    public var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private lazy var authorizationHandler: ChallengesHandlerDelegate = dependenciesEngine.resolve()
    
    public init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setUpDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: AuthorizationModuleViewController.self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    public func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    public func close() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    public func showEmptyAuthorization() {
        let coordinator = NoOperationToConfirmCoordinator(dependenciesResolver: dependenciesEngine,
                                                    navigationController: navigationController)
        coordinator.onCloseConfirmed = { [weak self] in
            self?.close()
        }
        
        coordinator.start()
    }
    
    public func showOperationToConfirm() {
        let coordinator = OperationToConfirmCoordinator(dependenciesResolver: dependenciesEngine,
                                                        navigationController: navigationController)
        coordinator.start()
        removeModuleControllerFromStack()
    }
    
    public func showAuthorization(for challenge: ChallengeRepresentable) {
           authorizationHandler.handle(challenge, authorizationId: "") { [weak self] challengeResult in
               guard let self = self else { return }
               
               switch(challengeResult) {
               case .handled(_):
                   //TODO: handle success challengeResult
                   print("success")
               default:
                   print("error")
                   //TODO: handle success challengeResult 
               }
           }
           removeModuleControllerFromStack()
       }
}

extension AuthorizationModuleCoordinator {
    private func setUpDependencies() {
        dependenciesEngine.register(for: AuthorizationModuleCoordinatorProtocol.self) { _ in
            self
        }
        dependenciesEngine.register(for: AuthorizationModulePresenterProtocol.self) { resolver in
            AuthorizationModulePresenter(dependenciesResolver: resolver)
        }
        
        dependenciesEngine.register(for: AuthorizationModuleViewController.self) { resolver in
            let presenter = resolver.resolve(for: AuthorizationModulePresenterProtocol.self)
            let viewController = AuthorizationModuleViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
    
    func removeModuleControllerFromStack() {
        let firstIndex = navigationController?.viewControllers.firstIndex {
            $0 is AuthorizationModuleViewController
        }
        guard let count = navigationController?.viewControllers.count,
              let index = firstIndex,
              count > index else { return }
        
        navigationController?.viewControllers.remove(at: index)
    }
}
