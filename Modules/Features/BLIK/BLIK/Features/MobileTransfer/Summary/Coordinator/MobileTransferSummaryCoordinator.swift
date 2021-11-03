import UI
import Models
import Commons

/**
    #Add method that must be handle by the MobileTransferSummaryCoordinator like 
    navigation between the module scene and so on.
*/
protocol MobileTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment()
    func goToGlobalPosition()
    func goToBlikCode()
    func shareSummary()
    func setDeviceAsTrusted()
}

final class MobileTransferSummaryCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let summary: MobileTransferSummary
    private lazy var informRecipientHandler = InformRecipientHandler()

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         summary: MobileTransferSummary) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.summary = summary
        self.setupDependencies()
    }
    
    func start() {
        let presenter = MobileTransferSummaryPresenter(dependenciesResolver: dependenciesEngine, summary: summary)
        let controller = MobileTransferSummaryViewController(presenter: presenter)
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension MobileTransferSummaryCoordinator: MobileTransferSummaryCoordinatorProtocol {
    func goToMakeAnotherPayment() {
        let contactsVC = navigationController?.viewControllers.reversed().first(where: { $0 is ContactsViewController })
        if let contactsVC = contactsVC {
            self.navigationController?.popToViewController(contactsVC, animated: true)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToBlikCode() {
        let blikHomeVC = navigationController?.viewControllers.reversed().first(where: { $0 is BLIKHomeViewController })
        if let blikHomeVC = blikHomeVC {
            self.navigationController?.popToViewController(blikHomeVC, animated: true)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func shareSummary() {
        guard let navigation = navigationController else { return }
        informRecipientHandler.shareSummary(summary, in: navigation)
    }
    
    func setDeviceAsTrusted() {
        //TODO: Implement setDeviceAsTrusted under https://godzilla.centrala.bzwbk:9998/browse/TAP-1650
    }
}

/**
 #Register Scene depencencies.
*/

private extension MobileTransferSummaryCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: MobileTransferSummaryCoordinatorProtocol.self) { _ in
            return self
        }

        self.dependenciesEngine.register(for: MobileTransferSummaryViewModelMapping.self) { _ in
            return MobileTransferSummaryViewModelMapper()
        }
        
        self.dependenciesEngine.register(for: GetTransactionUseCaseProtocol.self) { resolver in
            return GetTransactionUseCase(dependenciesResolver: resolver)
        }
    }
}
