
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
    private var acceptZusTransactionUseCase: AcceptZusTransactionProtocol {
        dependenciesResolver.resolve()
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
        self.view?.showLoader()
        Scenario(useCase: acceptZusTransactionUseCase,
                 input: .init(model: model))
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] result in
                guard let self = self else { return }
                self.view?.hideLoader {
                    self.coordinator.showSummary(with: result.summary)
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
                    let errorResult = AcceptZusTransactionErrorResult(rawValue: error.getErrorDesc() ?? "")
                    switch errorResult {
                    case .noConnection:
                        self?.showError(with: "pl_generic_alert_textUnstableConnection")
                    case .accountOnBlacklist:
                        self?.showError(with: "#Sprawdź poprawność wprowadzonego numeru rachunku. Przelew na wskazany rachunek może być zrealizowany wyłącznie w Oddziale Banku.")
                    case .expressEecipientInactive:
                        self?.showError(with: "#Bank odbiorcy nie obsługuje tego typu przelewów.")
                    case .limitExceeded:
                        self?.showError(with: "pl_generic_alert_textDayLimit", nameImage: "icnAlert")
                    default:
                        self?.handleServiceInaccessible()
                    }
                }
            }
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

