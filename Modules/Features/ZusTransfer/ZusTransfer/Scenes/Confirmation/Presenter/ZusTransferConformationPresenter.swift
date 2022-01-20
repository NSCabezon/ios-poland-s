
import Commons
import CoreDomain
import CoreFoundationLib
import PLCommons

protocol ZusTransferConfirmationPresenterProtocol {
    var view: ZusTransferConfirmationViewControllerProtocol? { get set }
    func goBack()
    func backToTransfer()
    func confirmTapped()
    func viewDidLoad()
}

final class ZusTransferConfirmationPresenter {
    var view: ZusTransferConfirmationViewControllerProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let model: ZusTransferModel?
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    
    init(dependenciesResolver: DependenciesResolver,
         model: ZusTransferModel?) {
        self.dependenciesResolver = dependenciesResolver
        self.model = model
    }
    
    private func prepareViewModel() {
        guard let model = model else { return }
        view?.setViewModel(ZusTransferConfirmationViewModel(transfer: model))
    }
}

extension ZusTransferConfirmationPresenter: ZusTransferConfirmationPresenterProtocol {

    func goBack() {
        coordinator.pop()
    }
    
    func backToTransfer() {
        coordinator.backToTransfer()
    }
    
    func confirmTapped() {
        guard let model = model else { return }
        //TODO: send accept transaction request and show summary
    }
    
    func viewDidLoad() {
        prepareViewModel()
    }

    func showError(with key: String, nameImage: String = "icnAlertError") {
        view?.showErrorMessage(localized(key), image: nameImage, onConfirm: { [weak self] in
            self?.coordinator.pop()
        })
    }
    
    func handleServiceInaccessible() {
        view?.showErrorMessage(localized("pl_generic_alert_textTryLater"), image: "icnAlertError", onConfirm: { [weak self] in
            self?.coordinator.backToTransfer()
        })
    }
}

private extension ZusTransferConfirmationPresenter {
    var coordinator: ZusTransferConfirmationCoordinatorProtocol {
        dependenciesResolver.resolve(for: ZusTransferConfirmationCoordinatorProtocol.self)
    }
}

