import Foundation
import Commons
import Operative

final class CreditCardRepaymentFinishingCoordinator {
    private let dependenciesEngine: DependenciesDefault
    private weak var navigationController: UINavigationController?
    
    
    init(dependenciesEngine: DependenciesDefault, navigatorController: UINavigationController?) {
        self.dependenciesEngine = dependenciesEngine
        self.navigationController = navigatorController
    }
}

extension CreditCardRepaymentFinishingCoordinator: CreditCardRepaymentFinishingCoordinatorProtocol {
    
    func goToGlobalPosition(_ coordinator: OperativeContainerCoordinatorProtocol) {
        guard let controller = coordinator.sourceView else {
            coordinator.navigationController?.popToRootViewController(animated: true)
            return
        }
        // TODO: This implementation might be different when true GlobalPosition will be available
        self.navigationController?.popToViewController(controller, animated: true)
    }
    
    func goToMakeAnotherPayment(_ coordinator: OperativeContainerCoordinatorProtocol) {
        guard let controller = coordinator.sourceView else {
            coordinator.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        self.navigationController?.popToViewController(controller, animated: true)
        
        let reLaunchCoordinator = CreditCardRepaymentModuleCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController
        )
        reLaunchCoordinator.start()
    }
}
