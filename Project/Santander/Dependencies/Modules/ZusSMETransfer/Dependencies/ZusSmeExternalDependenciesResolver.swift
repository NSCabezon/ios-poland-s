import UI
import ZusSMETransfer
import CoreFoundationLib
import CoreDomain
import Foundation

extension ModuleDependencies: ZusSMEExternalDependenciesResolver {
    func zusSMETransferFormCoordinator() -> ZusSMETransferFormCoordinator {
        DefaultZusSMETransferFormCoordinator(
            dependencies: self, navigationController: resolve()
        )
    }
    
    func resolve() -> StringLoader {
        let oldResolver: DependenciesResolver = resolve()
        return oldResolver.resolve()
    }
}
