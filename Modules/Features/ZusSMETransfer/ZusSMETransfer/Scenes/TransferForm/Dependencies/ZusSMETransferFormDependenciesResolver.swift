import UI
import CoreFoundationLib
import Foundation

protocol ZusSMETransferFormDependenciesResolver {
    var external: ZusSMETransferFormExternalDependenciesResolver { get }
    func resolve() -> ZusSMETransferFormViewModel
    func resolve() -> ZusSMETransferFormViewController
    func resolve() -> ZusSMETransferFormCoordinator
    func resolve() -> DataBinding
}

extension ZusSMETransferFormDependenciesResolver {
    
    func resolve() -> ZusSMETransferFormViewModel {
        ZusSMETransferFormViewModel(dependencies: self)
    }
    
    func resolve() -> ZusSMETransferFormViewController {
        ZusSMETransferFormViewController(dependencies: self)
    }
}
