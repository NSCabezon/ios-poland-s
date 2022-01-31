import UI
import CoreFoundationLib
import Commons

protocol ZusTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment()
    func goToGlobalPosition()
}

final class ZusTransferSummaryCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let summary: ZusTransferSummary

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         summary: ZusTransferSummary) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.summary = summary
        self.setupDependencies()
    }
    
    func start() {
        let presenter = ZusTransferSummaryPresenter(dependenciesResolver: dependenciesEngine, summary: summary)
        let controller = ZusTransferSummaryViewController(presenter: presenter)
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ZusTransferSummaryCoordinator: ZusTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment() {
        if let zusTransferFormVC = navigationController?.viewControllers.reversed().first(where: { $0 is ZusTransferFormViewController }) {
            navigationController?.popToViewController(zusTransferFormVC, animated: true)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension ZusTransferSummaryCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusTransferSummaryCoordinatorProtocol.self) { _ in
            return self
        }
    }
}
