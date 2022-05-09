import CoreFoundationLib
import PLUI
import PLCommonOperatives
import SANLegacyLibrary

let BLIK_WEB_PURCHASE_DURATION: TimeInterval = 40
let BLIK_OTHER_DURATION: TimeInterval = 27

protocol BLIKConfirmationPresenterProtocol: MenuTextWrapperProtocol {
    var view: BLIKConfirmationViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func didSelectClose()
    func didSelectBack()
    func didSelectConfirm()
}

final class BLIKConfirmationPresenter {
    weak var view: BLIKConfirmationViewProtocol?
    private var viewModel: BLIKTransactionViewModel?
    
    let dependenciesResolver: DependenciesResolver
    private let timer = TimerHandler()
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private let notificationSchemaId = "466"
    private var totalDuration: TimeInterval?
    private var cancelBLIKTransactionUseCase: CancelBLIKTransactionProtocol {
        dependenciesResolver.resolve()
    }
    private var acceptBLIKTransactionUseCase: AcceptBLIKTransactionProtocol {
        dependenciesResolver.resolve()
    }
    private var blikPrepareChallengeUseCase: BlikPrepareChallengeUseCaseProtocol {
        dependenciesResolver.resolve()
    }
    private var viewModelProvider: BLIKTransactionViewModelProviding {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    private var authorizationHandler: BlikChallengesHandlerDelegate {
        dependenciesResolver.resolve(for: BlikChallengesHandlerDelegate.self)
    }
    private var notifyDeviceUseCase: NotifyDeviceUseCaseProtocol {
        dependenciesResolver.resolve(for: NotifyDeviceUseCaseProtocol.self)
    }
    private var penndingChallengeUseCase: PenndingChallengeUseCaseProtocol {
        dependenciesResolver.resolve(for: PenndingChallengeUseCaseProtocol.self)
    }

    init(dependenciesResolver: DependenciesResolver) {
        self.dependenciesResolver = dependenciesResolver
    }
}

extension BLIKConfirmationPresenter: BLIKConfirmationPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        viewModelProvider.getViewModel { [weak self] result in
            self?.view?.hideLoader(completion: {
                switch result {
                case let .success(viewModel):
                    self?.handleFetchedViewModel(viewModel)
                case .failure:
                    self?.showServiceInaccessibleError()
                }
            })
        }
    }
    
    func viewWillAppear() {
        guard let totalDuration = totalDuration else { return }
        if self.timer.counter <= 0 {
            self.cancelTransaction(type: .timeout)
        }
        view?.startProgressAnimation(totalDuration: totalDuration, remainingDuration: TimeInterval(timer.counter))
    }
    
    func didSelectClose() {
        let dialog = confirmationDialogFactory.createEndProcessDialog {[weak self] in
            self?.cancelTransaction(type: .exit)
        } declineAction: {}
        
        view?.showDialog(dialog)
    }
    
    func didSelectBack() {
        cancelTransaction(type: .exit)
    }

    func didSelectConfirm() {
        confirmTransaction()
    }
}

private extension BLIKConfirmationPresenter {
    var coordinator: BLIKConfirmationCoordinatorProtocol {
        return self.dependenciesResolver.resolve(for: BLIKConfirmationCoordinatorProtocol.self)
    }
    
    func handleFetchedViewModel(_ viewModel: BLIKTransactionViewModel) {
        self.viewModel = viewModel
        let time = viewModel.remainingTime + (viewModel.transferType == .blikWebPurchases ? BLIK_WEB_PURCHASE_DURATION : BLIK_OTHER_DURATION)
        totalDuration = time
        startCountdown(totalDuration: time , remainingDuration: time)
        view?.setViewModel(viewModel)
    }
    
    func startCountdown(totalDuration: TimeInterval, remainingDuration: TimeInterval) {
        timer.didUpdate = { [weak self] counter in
            self?.view?.updateCounter(remainingSeconds: counter)
        }
        
        timer.didEnd = {[weak self] in
            self?.cancelTransaction(type: .timeout)
        }

        view?.startProgressAnimation(totalDuration: totalDuration, remainingDuration: remainingDuration)
        timer.startTimer(duration: remainingDuration)
    }
    
    func cancelTransaction(type: TransactionCancelationData.CancelType) {
        guard let viewModel = viewModel,
              coordinator.isBlikConfirmationViewControllerPresented() else { return }
        timer.stopTimer()
        view?.showLoader()
        Scenario(useCase: cancelBLIKTransactionUseCase,
                 input: .init(trnId: viewModel.trnId,
                              trnDate: viewModel.transactionDate,
                              cancelType: type))
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] _ in
                self?.view?.hideLoader() {
                    guard let strongSelf = self else { return }
                    let cancelationData = strongSelf.getTransactionCancelationData(with: type)
                    self?.coordinator.cancelTransfer(withData: cancelationData)
                }
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader {
                    self?.showServiceInaccessibleError()
                }
            }
    }
    
    func confirmTransaction() {
        guard let viewModel = viewModel else { return }
        var notifyDeviceUseCaseOutput: NotifyDeviceUseCaseOutput?
        view?.showLoader()
        Scenario(useCase: blikPrepareChallengeUseCase, input: .init(model: viewModel.transaction))
            .execute(on: useCaseHandler)
            .then(scenario: { [weak self] output ->Scenario<NotifyDeviceUseCaseInput, NotifyDeviceUseCaseOutput, StringErrorOutput>? in
                guard let self = self else { return nil }
                let notifyDeviceUseCaseInput = NotifyDeviceUseCaseInput(
                    challenge: output.challenge,
                    softwareTokenType: nil,
                    alias: "",
                    iban: IBANRepresented(ibanString: ""),
                    amount: AmountDTO(
                        value: viewModel.transaction.amount,
                        currency: CurrencyDTO(
                            currencyName: CurrencyType.złoty.name,
                            currencyType: .złoty
                        )
                    ),
                    notificationSchemaId: self.notificationSchemaId,
                    variables: []
                )
                return Scenario(useCase: self.notifyDeviceUseCase, input: notifyDeviceUseCaseInput)
            })
            .then(scenario: { [weak self] output ->Scenario<Void, PenndingChallengeUseCaseOutput, StringErrorOutput>? in
                guard let self = self else { return nil }
                notifyDeviceUseCaseOutput = output
                return Scenario(useCase: self.penndingChallengeUseCase)
            })
            .onSuccess({ [weak self] output in
                self?.view?.hideLoader {
                    guard let authorizationId = notifyDeviceUseCaseOutput?.authorizationId else { return }
                    self?.showAuthorization(
                        with: AuthorizationModel(
                            authorizationId: authorizationId,
                            challenge: output.challenge
                        )
                    )
                }
            })
            .onError { [weak self] error in
                self?.timer.stopTimer()
                self?.view?.hideLoader(completion: {
                    self?.showServiceInaccessibleError()
                })
            }
    }
    
    func showAuthorization(with model: AuthorizationModel) {
        authorizationHandler.handle(
            model.challenge,
            authorizationId: "\(model.authorizationId)",
            progressTotalTime: Float(timer.counter)
        ) { [weak self] challengeResult in
            switch(challengeResult) {
            case .handled(_):
                self?.startAcceptTransaction()
            default:
                self?.timer.stopTimer()
                self?.showServiceInaccessibleError()
            }
        } bottomSheetDismissedClosure: { [weak self] in
            guard let self = self else { return }
            if self.timer.counter <= 0 {
                self.coordinator.closeControllerIfOtherThanBlikConfirmationVC()
            }
        }
    }
    
    func startAcceptTransaction() {
        guard let viewModel = viewModel else { return }
        timer.stopTimer()
        Scenario(useCase: acceptBLIKTransactionUseCase,
                 input: .init(trnId: viewModel.trnId,
                              trnDate: viewModel.transactionDate))
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] _ in
                self?.view?.hideLoader() {
                    self?.coordinator.goToSummary(with: viewModel)
                }
            }
            .onError {[weak self] error in
                guard let errorDesc = error.getErrorDesc() else {
                    self?.view?.hideLoader {
                        self?.showServiceInaccessibleError()
                    }
                    return
                }
                let errorDescComponents = errorDesc.components(separatedBy: ".")
                let errorKey = errorDescComponents[0]
                let errorCode = Int(errorDescComponents[1])
                var errorImage = ""
                if errorCode == BlikError.ErrorCode2.cycleLimitExceeded.rawValue ||
                    errorCode == BlikError.ErrorCode2.trnLimitExceeded.rawValue ||
                    errorCode == BlikError.ErrorCode2.pw_limit_exceeded.rawValue {
                    errorImage = "icnAlert"
                } else {
                    errorImage = "icnAlertError"
                }
                self?.view?.hideLoader {
                    self?.showError(with: errorKey, image: errorImage)
                }
            }
    }

    func showServiceInaccessibleError() {
        view?.showServiceInaccessibleMessage {[weak self] in
            self?.coordinator.goToGlobalPosition()
        }
    }
    
    func showError(with key: String, image: String) {
        view?.showErrorMessage(localized(key), image: image) {[weak self] in
            self?.coordinator.goToGlobalPosition()
        }
    }
    
    func getTransactionCancelationData(with type: TransactionCancelationData.CancelType) -> TransactionCancelationData {
        guard let alias = viewModel?.aliasUsedInTransaction else {
            return TransactionCancelationData(
                cancelType: type,
                aliasContext: .transactionPerformedWithoutAlias
            )
        }
        
        return TransactionCancelationData(
            cancelType: type,
            aliasContext: .transactionPerformedWithAlias(alias)
        )
    }
}
