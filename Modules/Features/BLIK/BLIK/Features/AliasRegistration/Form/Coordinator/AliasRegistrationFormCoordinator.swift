import UI
import CoreFoundationLib

protocol AliasRegistrationFormCoordinatorProtocol {
    func goToAliasRegistrationSummary()
    func close()
    func goToGlobalPosition()
}

final class AliasRegistrationFormCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let registerAliasInput: RegisterAliasInput

    init(
        registerAliasInput: RegisterAliasInput,
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.registerAliasInput = registerAliasInput
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let presenter = AliasRegistrationFormPresenter(
            registerAliasInput: registerAliasInput,
            dependenciesResolver: dependenciesEngine
        )
        let controller = AliasRegistrationFormViewController(presenter: presenter)
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AliasRegistrationFormCoordinator: AliasRegistrationFormCoordinatorProtocol {
    func goToAliasRegistrationSummary() {
        let coordinator = AliasRegistrationSummaryCoordinator(
            dependenciesResolver: dependenciesEngine,
            navigationController: navigationController,
            registeredAliasType: registerAliasInput.aliasProposal.type
        )
        coordinator.start()
    }
    
    func close() {
        navigationController?.popViewController(animated: true)
    }
    
    func goToGlobalPosition() {
        navigationController?.popToRootViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension AliasRegistrationFormCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: AliasRegistrationFormCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: RegisterAliasUseCaseProtocol.self) { resolver in
            return RegisterAliasUseCase(dependenciesResolver: resolver)
        }
    }
}
