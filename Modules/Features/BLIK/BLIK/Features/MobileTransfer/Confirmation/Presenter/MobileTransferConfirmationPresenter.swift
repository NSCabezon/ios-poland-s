import CoreFoundationLib
import PLUI
import SANPLLibrary
import PLCommonOperatives

protocol MobileTransferConfirmationPresenterProtocol {
    var view: MobileTransferConfirmationViewControllerProtocol? { get set }
    func goBack()
    func closeProcess()
    func confirmTapped()
    func viewDidLoad()
}

final class MobileTransferConfirmationPresenter {
    var view: MobileTransferConfirmationViewControllerProtocol?
    private let dependenciesResolver: DependenciesResolver
    private let viewModel: MobileTransferViewModel?
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private let isDstAccInternal: Bool
    private let dstAccNo: String
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    private var acceptTransactionUseCase: AcceptTransactionProtocol {
        dependenciesResolver.resolve()
    }
    private var getIndividualUseCase: GetIndividualProtocol {
        dependenciesResolver.resolve()
    }
    private var managersProvider: PLManagersProviderProtocol {
        dependenciesResolver.resolve(for: PLManagersProviderProtocol.self)
    }
    private var authorizationHandler: ChallengesHandlerDelegate {
        dependenciesResolver.resolve(for: ChallengesHandlerDelegate.self)
    }
    private var mapper: MobileTransferSendMoneyInputMapping {
        dependenciesResolver.resolve()
    }

    init(dependenciesResolver: DependenciesResolver,
         viewModel: MobileTransferViewModel,
         isDstAccInternal: Bool,
         dstAccNo: String
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.viewModel = viewModel
        self.isDstAccInternal = isDstAccInternal
        self.dstAccNo = dstAccNo
    }
}

extension MobileTransferConfirmationPresenter: MobileTransferConfirmationPresenterProtocol {
    
    func goBack() {
        coordinator.pop()
    }
    
    func closeProcess() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {[weak self] in
            self?.coordinator.backToBlikHome()
        }
        declineAction: {}
        view?.showDialog(dialog)
    }
    
    func confirmTapped() {
        guard let viewModel = viewModel else { return }
        view?.showLoader()
        guard let userId = try? managersProvider.getLoginManager().getAuthCredentials().userId else {
            return
        }
        let sendMoneyInput = mapper.map(with: viewModel, dstAccNo: dstAccNo, isDstAccInternal: isDstAccInternal, userId: userId)
        let notifyDeviceInput = mapper.mapPartialNotifyDeviceInput(with: viewModel, dstAccNo: dstAccNo, isDstAccInternal: isDstAccInternal)
        let authorizeTransactionInput = AuthorizeTransactionUseCaseInput(sendMoneyConfirmationInput: sendMoneyInput, partialNotifyDeviceInput: notifyDeviceInput)
        
        Scenario(useCase: AuthorizeTransactionUseCase(dependenciesResolver: dependenciesResolver), input: authorizeTransactionInput)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] output in
                self?.view?.hideLoader {
                        self?.authorizationHandler.handle(output.pendingChallenge, authorizationId: "\(output.authorizationId)", completion: { [weak self] challangeResult in
                            switch challangeResult {
                            case .handled(_):
                                self?.startAcceptTransaction()
                            default:
                                self?.showServiceInaccessibleError()
                            }
                        }
                    )
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
                    if error.getErrorDesc() == "noConnection" {
                        self?.showError(with: "pl_blik_alert_text_unstableConnection")
                        return
                    }
                    let plError = error.getPLErrorDTO()
                    if let blikErrorKey = BlikError(with: plError)?.errorKey, !blikErrorKey.isEmpty {
                        self?.showError(with: blikErrorKey)
                        return
                    }
                    self?.showError(with: "pl_blik_alert_text_error")
                }
            }
    }
    
    func startAcceptTransaction() {
        guard let viewModel = viewModel else { return }
        self.view?.showLoader()
        Scenario(useCase: acceptTransactionUseCase,
                 input: .init(form: viewModel, isDstAccInternal: isDstAccInternal, dstAccNo: dstAccNo))
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] result in
                if let storngSelf = self {
                    Scenario(useCase: storngSelf.getIndividualUseCase)
                        .execute(on: storngSelf.useCaseHandler)
                        .onSuccess { [weak self] customer in
                            let mapper = MobileTransferSummaryMapper()
                            let summaryModel = mapper.map(summary: result.summary, transferType: result.transferType, customer: customer.customer)
                            self?.view?.hideLoader {
                                self?.coordinator.closeAuthorization()
                                self?.coordinator.showSummary(with: summaryModel)
                            }
                        }
                        .onError { [weak self] error in
                            self?.view?.hideLoader {
                                self?.coordinator.closeAuthorization()
                                guard let errorKey = error.getErrorDesc() else {
                                    self?.showServiceInaccessibleError()
                                    return
                                }
                                self?.showError(with: errorKey)
                            }
                        }
                } else {
                    self?.view?.hideLoader {
                        self?.coordinator.closeAuthorization()
                        self?.showServiceInaccessibleError()
                        return
                    }
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
                    self?.coordinator.closeAuthorization()
                    guard let errorKey = error.getErrorDesc() else {
                        self?.showServiceInaccessibleError()
                        return
                    }
                    self?.showError(with: errorKey)
                }
            }
    }
    
    func viewDidLoad() {
        guard let viewModel = viewModel else { return }
        view?.setViewModel(viewModel)
    }
    
    func showServiceInaccessibleError() {
        view?.showServiceInaccessibleMessage { [weak self] in
            self?.coordinator.backToTransfer()
        }
    }
    
    func showError(with key: String) {
        view?.showErrorMessage(localized(key)) { [weak self] in
            self?.coordinator.backToTransfer()
        }
    }
}

private extension MobileTransferConfirmationPresenter {
    var coordinator: MobileTransferConfirmationCoordinatorProtocol {
        dependenciesResolver.resolve(for: MobileTransferConfirmationCoordinatorProtocol.self)
    }
}
