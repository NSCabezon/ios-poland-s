import OpenCombine
import CoreFoundationLib

enum TransferFormState: State {
    case idle
}

final class ZusSMETransferFormViewModel {
    var state: AnyPublisher<TransferFormState, Never>
    var language: String {
        let loader: StringLoader = dependencies.external.resolve()
        return loader.getCurrentLanguage().appLanguageCode
    }
    private let dependencies: ZusSMETransferFormDependenciesResolver
    private let stateSubject = CurrentValueSubject<TransferFormState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    private var coordinator: ZusSMETransferFormCoordinator {
        return dependencies.resolve()
    }
    
    init(dependencies: ZusSMETransferFormDependenciesResolver) {
        self.dependencies = dependencies
        state = stateSubject.eraseToAnyPublisher()
    }
    
    func didSelectGoBack() {
        coordinator.back()
    }
    
    func didSelectCloseProcess() {
        coordinator.closeProcess()
    }
}


