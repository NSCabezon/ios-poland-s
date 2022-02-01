import UI
import CoreFoundationLib
import CoreFoundationLib
import Operative

protocol AliasRegistrationSummaryCoordinatorProtocol {
    func goToGlobalPosition()
    func goToMakeAnotherPayment()
}

final class AliasRegistrationSummaryCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let registeredAliasType: Transaction.AliasProposalType

    init(
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?,
        registeredAliasType: Transaction.AliasProposalType
    ) {
        self.navigationController = navigationController
        self.registeredAliasType = registeredAliasType
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let controller = self.dependenciesEngine.resolve(for: AliasRegistrationSummaryViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AliasRegistrationSummaryCoordinator: AliasRegistrationSummaryCoordinatorProtocol {
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func goToMakeAnotherPayment() {
        let blikHomeVC = navigationController?
            .viewControllers
            .reversed()
            .first(where: { $0 is BLIKHomeViewController })

        guard let blikHomeViewControlelr = blikHomeVC else {
            navigationController?.popToRootViewController(animated: true)
            return
        }

        // TODO: For now this action goes to BLIK main screen. In task TAP-1655 this should be change
        navigationController?.popToViewController(blikHomeViewControlelr, animated: true)
    }
}

private extension AliasRegistrationSummaryCoordinator {
    func setupDependencies() {
        self.dependenciesEngine.register(for: AliasRegistrationSummaryCoordinatorProtocol.self) { _ in
            return self
        }
         
        self.dependenciesEngine.register(for: AliasRegistrationSummaryPresenterProtocol.self) { resolver in
            return AliasRegistrationSummaryPresenter(
                dependenciesResolver: resolver
            )
        }

        self.dependenciesEngine.register(for: AliasRegistrationSummaryViewController.self) { [registeredAliasType] resolver in
            let presenter = resolver.resolve(for: AliasRegistrationSummaryPresenterProtocol.self)
            let viewController = AliasRegistrationSummaryViewController(
                presenter: presenter,
                registeredAliasType: registeredAliasType
            )
            presenter.view = viewController
            return viewController
        }
    }
}
