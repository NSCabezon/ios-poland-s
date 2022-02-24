import UI
import CoreFoundationLib
import SANPLLibrary
import PLCommons

protocol CancelTransactionCoordinatorProtocol {
    func showAliasesList()
    func showAliasDeletion(of alias: BlikAlias)
    func goToGlobalPosition()
}

final class CancelTransactionCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let cancelationData: TransactionCancelationData
    
    init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        cancelationData: TransactionCancelationData
    ) {
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.cancelationData = cancelationData
        self.setUpDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: CancelTransactionViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension CancelTransactionCoordinator: CancelTransactionCoordinatorProtocol {
    func showAliasesList() {
        let coordinator = AliasListSettingsCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController
        )
        coordinator.start()
    }
    
    func showAliasDeletion(of alias: BlikAlias) {
        let coordinator = DeleteAliasCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            alias: alias
        )
        coordinator.start()
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension CancelTransactionCoordinator {
    func setUpDependencies() {
        dependenciesEngine.register(for: CancelTransactionCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: BlikAliasMapping.self) { _ in
            return BlikAliasMapper(dateFormatter: PLTimeFormat.YYYYMMDD_HHmmssSSS.createDateFormatter())
        }
            
        dependenciesEngine.register(for: GetAliasesUseCaseProtocol.self) { resolver in
            return GetAliasesUseCase(
                managersProvider: resolver.resolve(for: PLManagersProviderProtocol.self),
                modelMapper: resolver.resolve(for: BlikAliasMapping.self)
            )
        }
         
        dependenciesEngine.register(for: CancelTransactionPresenterProtocol.self) { [cancelationData] resolver in
            return CancelTransactionPresenter(
                dependenciesResolver: resolver,
                cancelationData: cancelationData
            )
        }
        
        dependenciesEngine.register(for: CancelTransactionViewController.self) { resolver in
            var presenter = resolver.resolve(for: CancelTransactionPresenterProtocol.self)
            let viewController = CancelTransactionViewController(presenter: presenter)
            presenter.view = viewController
            return viewController
        }
    }
}
