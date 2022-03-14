import UI
import CoreFoundationLib
import CoreDomain
import OpenCombine
import UIKit

public protocol ZusSMETransferFormCoordinator: BindableCoordinator {
    func back()
    func closeProcess()
}

final public class DefaultZusSMETransferFormCoordinator {
    weak public var navigationController: UINavigationController?
    public var onFinish: (() -> Void)?
    public var childCoordinators: [Coordinator] = []
    lazy public var dataBinding: DataBinding = dependencies.resolve()
    private let externalDependencies: ZusSMETransferFormExternalDependenciesResolver
    private lazy var dependencies: Dependency = {
        Dependency(dependencies: externalDependencies, coordinator: self)
    }()

    public init(dependencies: ZusSMETransferFormExternalDependenciesResolver, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.externalDependencies = dependencies
    }
    
    public func start() {
        navigationController?.pushViewController(dependencies.resolve(), animated: true)
    }
}

extension DefaultZusSMETransferFormCoordinator: ZusSMETransferFormCoordinator {
    public func back() {
        navigationController?.popViewController(animated: true)
    }
    
    public func closeProcess() {
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension DefaultZusSMETransferFormCoordinator {
    struct Dependency: ZusSMETransferFormDependenciesResolver {
        let dependencies: ZusSMETransferFormExternalDependenciesResolver
        let coordinator: ZusSMETransferFormCoordinator
        let dataBinding = DataBindingObject()
        
        var external: ZusSMETransferFormExternalDependenciesResolver {
            return dependencies
        }
        
        func resolve() -> ZusSMETransferFormCoordinator {
            return coordinator
        }
        
        func resolve() -> DataBinding {
            return dataBinding
        }
    }
}
