import UI
import CoreFoundationLib
import CoreFoundationLib

/**
    #Add method that must be handle by the CancelTransactionCoordinator like 
    navigation between the module scene and so on.
*/
protocol CancelTransactionCoordinatorProtocol {
    func goToGlobalPosition()
}

final class CancelTransactionCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let cancelType: CancelType
    
    init(dependenciesResolver: DependenciesResolver, navigationController: UINavigationController?, cancelType: CancelType) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.cancelType = cancelType
        self.setUpDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: CancelTransactionViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CancelTransactionCoordinator: CancelTransactionCoordinatorProtocol {
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension CancelTransactionCoordinator {
    func setUpDependencies() {
        self.dependenciesEngine.register(for: CancelTransactionCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: CancelTransactionPresenterProtocol.self) {[cancelType] resolver in
            return CancelTransactionPresenter(dependenciesResolver: resolver, cancelType: cancelType)
        }
        
        self.dependenciesEngine.register(for: CancelTransactionViewController.self) { resolver in
            var presenter = resolver.resolve(for: CancelTransactionPresenterProtocol.self)
            let viewController = CancelTransactionViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}
