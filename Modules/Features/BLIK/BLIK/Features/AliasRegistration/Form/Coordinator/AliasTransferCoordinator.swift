import UI
import Models
import Commons

protocol AliasTransferCoordinatorProtocol {
    func close()
}

final class AliasTransferCoordinator: ModuleCoordinator {
    weak var navigationController: UINavigationController?
    private let dependenciesEngine: DependenciesDefault
    private let registerAliasInput: RegisterBlikAliasInput

    init(
        registerAliasInput: RegisterBlikAliasInput,
        dependenciesResolver: DependenciesResolver,
        navigationController: UINavigationController?
    ) {
        self.registerAliasInput = registerAliasInput
        self.navigationController = navigationController
        self.dependenciesEngine = DependenciesDefault(father: dependenciesResolver)
        self.setupDependencies()
    }
    
    func start() {
        let presenter = AliasTransferPresenter(
            registerAliasInput: registerAliasInput,
            aliasType: .cookie, //TODO: Update alias type with a real transaction value
            dependenciesResolver: dependenciesEngine
        )
        let controller = AliasTransferViewController(presenter: presenter)
        presenter.view = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AliasTransferCoordinator: AliasTransferCoordinatorProtocol {
    func close() {
        navigationController?.popViewController(animated: true)
    }
}

/**
 #Register Scene depencencies.
*/

private extension AliasTransferCoordinator {
    func setupDependencies() {
        dependenciesEngine.register(for: AliasTransferCoordinatorProtocol.self) { _ in
            return self
        }
        
        dependenciesEngine.register(for: AliasTransactionRegisterAliasUseCaseProtocol.self) { resolver in
            return AliasTransactionRegisterAliasUseCase(dependenciesResolver: resolver)
        }
    }
}
