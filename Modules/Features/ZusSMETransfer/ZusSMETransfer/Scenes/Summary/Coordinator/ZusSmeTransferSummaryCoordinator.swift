import UI
import CoreFoundationLib

protocol ZusSmeTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment()
    func goToGlobalPosition()
}

final class ZusSmeTransferSummaryCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let summary: ZusSmeSummaryModel

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         summary: ZusSmeSummaryModel) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.summary = summary
        self.setupDependencies()
    }
    
    func start() {
        let presenter = ZusSmeTransferSummaryPresenter(dependenciesResolver: dependenciesEngine, summary: summary)
        let controller = ZusSmeTransferSummaryViewController(presenter: presenter)
        presenter.view = controller
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ZusSmeTransferSummaryCoordinator: ZusSmeTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment() {
        if let zusTransferFormVC = navigationController?.viewControllers.reversed().first(where: { $0 is ZusSmeTransferFormViewProtocol }) {
            navigationController?.popToViewController(zusTransferFormVC, animated: true)
            (zusTransferFormVC as? ZusSmeTransferFormViewProtocol)?.resetForm()
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

private extension ZusSmeTransferSummaryCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: ZusSmeTransferSummaryCoordinatorProtocol.self) { _ in
            return self
        }
    }
}
