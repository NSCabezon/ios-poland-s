import UI
import CoreFoundationLib
import CoreDomain
import OpenCombine

public protocol ZusSMETransferFormExternalDependenciesResolver: NavigationBarExternalDependenciesResolver {
    func resolve() -> NavigationBarItemBuilder
    func resolve() -> UINavigationController
    func resolve() -> StringLoader
    func zusSMETransferFormCoordinator() -> ZusSMETransferFormCoordinator
}

extension ZusSMETransferFormExternalDependenciesResolver {
    func resolve() -> NavigationBarItemBuilder {
        NavigationBarItemBuilder(dependencies: self)
    }
    
    func zusSMETransferFormCoordinator() -> ZusSMETransferFormCoordinator {
        DefaultZusSMETransferFormCoordinator(
            dependencies: self, navigationController: resolve()
        )
    }
}
