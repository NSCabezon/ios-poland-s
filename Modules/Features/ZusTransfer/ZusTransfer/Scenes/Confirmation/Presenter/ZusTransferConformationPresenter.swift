import SANLegacyLibrary
import CoreFoundationLib
import CoreDomain
import PLCommons
import SANPLLibrary
import PLCommonOperatives

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
    private var coordinator: ZusTransferConfirmationCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    private var authorizationHandler: ChallengesHandlerDelegate {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        dependenciesResolver.resolve()
    }
    private var acceptZusTransactionUseCase: AcceptZusTransactionProtocol {
        dependenciesResolver.resolve()
    }
    private var penndingChallengeUseCase: PenndingChallengeUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var prepareChallengeUseCase: ZusPrepareChallengeUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var notifyDeviceUseCase: NotifyDeviceUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var zusTransferSendMoneyInputMapper: ZusTransferSendMoneyInputMapping {
        dependenciesResolver.resolve(for: ZusTransferSendMoneyInputMapper.self)
    }
    
    private var managersProvider: PLManagersProviderProtocol {
        dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
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
        view?.showLoader()
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return
        }
        let sendMoneyInput = zusTransferSendMoneyInputMapper.map(with: model, userId: userId)
        let notifyDeviceInput = zusTransferSendMoneyInputMapper.mapPartialNotifyDeviceInput(with: model)
        let authorizeTransactionInput = AuthorizeTransactionUseCaseInput(sendMoneyConfirmationInput: sendMoneyInput, partialNotifyDeviceInput: notifyDeviceInput)
        
        Scenario(useCase: AuthorizeTransactionUseCase(dependenciesResolver: dependenciesResolver), input: authorizeTransactionInput)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader {
                    self?.showAuthorization(
                        with: AuthorizationModel(
                            authorizationId: output.authorizationId,
                            penndingChallenge: output.pendingChallenge
                        )
                    )
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
                    if let noConnectionError = AcceptZusTransactionErrorResult(rawValue: error.getErrorDesc() ?? "") {
                        self?.showErrorMessage(error: noConnectionError.rawValue)
                        return
                    }
                    let plError = error.getPLErrorDTO()
                    let zusError = ZusTransferError(with: plError)
                    self?.showErrorMessage(error: zusError?.errorResult.rawValue ?? "")
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
    
    func startAcceptTransaction() {
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
                    self?.showErrorMessage(error: error.getErrorDesc() ?? "")
                }
            }
    }
    
    func showAuthorization(with model: AuthorizationModel) {
        authorizationHandler.handle(model.penndingChallenge, authorizationId: "\(model.authorizationId)") { [weak self] challengeResult in
            switch(challengeResult) {
            case .handled(_):
                self?.startAcceptTransaction()
            default:
                self?.handleServiceInaccessible()
            }
        }
    }
    
    func showErrorMessage(error: String) {
        let errorResult = AcceptZusTransactionErrorResult(rawValue: error)
        switch errorResult {
        case .noConnection:
            self.showError(with: "pl_generic_alert_textUnstableConnection")
        case .accountOnBlacklist:
            self.showError(with: "#Sprawdź poprawność wprowadzonego numeru rachunku. Przelew na wskazany rachunek może być zrealizowany wyłącznie w Oddziale Banku.")
        case .expressEecipientInactive:
            self.showError(with: "#Bank odbiorcy nie obsługuje tego typu przelewów.")
        case .limitExceeded:
            self.showError(with: "pl_generic_alert_textDayLimit", nameImage: "icnAlert")
        default:
            self.handleServiceInaccessible()
        }
    }
}
