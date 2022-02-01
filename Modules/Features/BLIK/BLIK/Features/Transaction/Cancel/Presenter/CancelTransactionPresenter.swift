import CoreFoundationLib

enum CancelType: String {
    case timeout = "pl_blik_alert_timeOut"
    case exit = "pl_blik_alert_cancTransac"
}

protocol CancelTransactionPresenterProtocol: MenuTextWrapperProtocol {
    var view: CancelTransactionViewProtocol? { get set }
    var cancelType: CancelType { get }
    func goToGlobalPosition()
}

final class CancelTransactionPresenter {
    weak var view: CancelTransactionViewProtocol?
    internal let dependenciesResolver: DependenciesResolver
    let cancelType: CancelType

    init(dependenciesResolver: DependenciesResolver, cancelType: CancelType) {
        self.dependenciesResolver = dependenciesResolver
        self.cancelType = cancelType
    }
}

private extension CancelTransactionPresenter {
    var coordinator: CancelTransactionCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: CancelTransactionCoordinatorProtocol.self)
    }
}

extension CancelTransactionPresenter: CancelTransactionPresenterProtocol {
    func goToGlobalPosition() {
        coordinator.goToGlobalPosition()
    }
}
