import UI
import CoreFoundationLib

public protocol MobileTransferConfirmationCoordinatorProtocol {
    func pop()
    func backToBlikHome()
    func backToTransfer()
    func showSummary(with model: MobileTransferSummary)
}

public final class MobileTransferConfirmationCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let viewModel: MobileTransferViewModel
    private let isDstAccInternal: Bool
    private let dstAccNo: String

    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         viewModel: MobileTransferViewModel,
         isDstAccInternal: Bool,
         dstAccNo: String) {
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.isDstAccInternal = isDstAccInternal
        self.dstAccNo = dstAccNo
        setupDependencies()
    }
    
    public func start() {
        let presenter = MobileTransferConfirmationPresenter(dependenciesResolver: dependenciesEngine,
                                                            viewModel: viewModel,
                                                            isDstAccInternal: isDstAccInternal,
                                                            dstAccNo: dstAccNo)
        let controller = MobileTransferConfirmationViewController(presenter: presenter)
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

private extension MobileTransferConfirmationCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: MobileTransferConfirmationCoordinatorProtocol.self) { _ in
            self
        }
        
        self.dependenciesEngine.register(for: AcceptTransactionProtocol.self) { resolver in
            return AcceptTransactionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: GetIndividualProtocol.self) { resolver in
            return GetIndividualUseCase(dependencyResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: MobileTransferSendMoneyInputMapping.self) { resolver in
            return MobileTransferSendMoneyInputMapper(dependenciesResolver: resolver)
        }
    }
}

extension MobileTransferConfirmationCoordinator: MobileTransferConfirmationCoordinatorProtocol {
    
    public func backToBlikHome() {
        let blikHomeVC = navigationController?.viewControllers.reversed().first(where: { $0 is BLIKHomeViewController })
       
        if let blikHomeViewController = blikHomeVC {
            self.navigationController?.popToViewController(blikHomeViewController, animated: true)
            return
        }
        
        let contactsViewControllerIndex = navigationController?.viewControllers.firstIndex {
            $0 is ContactsViewController
        }
        guard let contactsViewControllerIndex = contactsViewControllerIndex,
              let parentController = navigationController?.viewControllers[safe: contactsViewControllerIndex - 1] else {
            navigationController?.popViewController(animated: true)
            return
            
        }
        navigationController?.popToViewController(parentController, animated: true)
    }
    
    public func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    public func showSummary(with model: MobileTransferSummary) {
        let coordinator = MobileTransferSummaryCoordinator(dependenciesResolver: dependenciesEngine,
                                                           navigationController: navigationController,
                                                           summary: model)
        
        coordinator.start()
    }
    
    public func backToTransfer() {
        navigationController?.popViewController(animated: true)
    }
}
