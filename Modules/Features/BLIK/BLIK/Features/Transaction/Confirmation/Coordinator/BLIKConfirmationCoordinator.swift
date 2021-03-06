import UI
import CoreFoundationLib
import PLCommonOperatives
import PLCommons

/**
    #Add method that must be handle by the BLIKConfirmationCoordinator like 
    navigation between the module scene and so on.
*/
protocol BLIKConfirmationCoordinatorProtocol {
    func cancelTransfer(withData: TransactionCancelationData)
    func goToSummary(with viewModel: BLIKTransactionViewModel)
    func goToGlobalPosition()
    func isBlikConfirmationViewControllerPresented() -> Bool
    func closeControllerIfOtherThanBlikConfirmationVC()
    func closeAuthorization()
}

final class BLIKConfirmationCoordinator: ModuleCoordinator {
    public weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let viewModelSource: BLIKTransactionViewModelSource
    
    init(dependenciesResolver: DependenciesResolver,
         navigationController: UINavigationController?,
         viewModelSource: BLIKTransactionViewModelSource
    ) {
        self.navigationController = navigationController
        self.viewModelSource = viewModelSource
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    public func start() {
        let controller = self.dependenciesEngine.resolve(for: BLIKConfirmationViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension BLIKConfirmationCoordinator: BLIKConfirmationCoordinatorProtocol {
    func cancelTransfer(withData cancelationData: TransactionCancelationData) {
        let coordinator = CancelTransactionCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            cancelationData: cancelationData
        )
        coordinator.start()
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToSummary(with viewModel: BLIKTransactionViewModel) {
        let coordinator = BLIKSummaryCoordinator(dependenciesResolver: dependenciesEngine,
                                                 navigationController: navigationController,
                                                 viewModel: viewModel)
        
        coordinator.start()
    }
    
    func isBlikConfirmationViewControllerPresented() -> Bool {
        if navigationController?.viewControllers.last is BLIKConfirmationViewController {
            return true
        }
        return false
    }
    
    func closeControllerIfOtherThanBlikConfirmationVC() {
        if !isBlikConfirmationViewControllerPresented() {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func closeAuthorization() {
        guard let confirmationVC = navigationController?.viewControllers.first(where: {
            $0 is BLIKConfirmationViewController
        }) else { return }
        navigationController?.popToViewController(confirmationVC, animated: false)
    }
}

/**
 #Register Scene depencencies.
*/

private extension BLIKConfirmationCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: BLIKConfirmationCoordinatorProtocol.self) { _ in
            return self
        }
        
        self.dependenciesEngine.register(for: CancelBLIKTransactionProtocol.self) { resolver in
            return CancelBLIKTransactionUseCase(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: AcceptBLIKTransactionProtocol.self) { resolver in
            return AcceptBLIKTransactionUseCase(dependenciesResolver: resolver)
        }

        self.dependenciesEngine.register(for: GetTrnToConfProtocol.self) { resolver in
            return GetTrnToConfUseCase(dependenciesResolver: resolver)
        }
         
        self.dependenciesEngine.register(for: TransactionMapping.self) { _ in
            return TransactionMapper()
        }
        
        self.dependenciesEngine.register(for: BLIKTransactionViewModelProviding.self) { [viewModelSource] resolver in
            switch viewModelSource {
            case let .prefetched(viewModel):
                return PrefetchedBLIKTransactionViewModelProvider(viewModel: viewModel)
            case .needsToBeFetched:
                return BLIKTransactionViewModelAsyncProvider(dependenciesResolver: resolver)
            }
        }
        
        self.dependenciesEngine.register(for: BLIKConfirmationPresenterProtocol.self) { resolver in
            return BLIKConfirmationPresenter(dependenciesResolver: resolver)
        }
        
        self.dependenciesEngine.register(for: BLIKConfirmationViewController.self) { resolver in
            var presenter = resolver.resolve(for: BLIKConfirmationPresenterProtocol.self)
            let viewController = BLIKConfirmationViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
        
        dependenciesEngine.register(for: BlikPrepareChallengeUseCaseProtocol.self) { resolver in
            BlikPrepareChallengeUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: NotifyDeviceUseCaseProtocol.self) { resolver in
            NotifyDeviceUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PenndingChallengeUseCaseProtocol.self) { resolver in
            PenndingChallengeUseCase(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PLTransactionParametersProviderProtocol.self) { resolver in
             PLTransactionParametersProvider(dependenciesResolver: resolver)
        }
        dependenciesEngine.register(for: PLDomesticTransactionParametersGenerable.self) { _ in
             PLDomesticTransactionParametersProvider()
        }
    }
}
