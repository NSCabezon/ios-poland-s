import Models
import Commons
import CoreFoundationLib
import PLUI

let BLIK_WEB_PURCHASE_DURATION: TimeInterval = 40
let BLIK_OTHER_DURATION: TimeInterval = 27

protocol BLIKConfirmationPresenterProtocol: MenuTextWrapperProtocol {
    var view: BLIKConfirmationViewProtocol? { get set }
    func viewDidLoad()
    
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

    private var cancelBLIKTransactionUseCase: CancelBLIKTransactionProtocol {
        dependenciesResolver.resolve()
    }
    private var acceptBLIKTransactionUseCase: AcceptBLIKTransactionProtocol {
        dependenciesResolver.resolve()
    }
    private var viewModelProvider: BLIKTransactionViewModelProviding {
        dependenciesResolver.resolve()
    }
    private var useCaseHandler: UseCaseHandler {
        return self.dependenciesResolver.resolve(for: UseCaseHandler.self)
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
    
    func cancelTransaction(type: CancelType) {
        guard let viewModel = viewModel else { return }
        timer.stopTimer()
        view?.showLoader()
        
        Scenario(useCase: cancelBLIKTransactionUseCase,
                 input: .init(trnId: viewModel.trnId,
                              trnDate: viewModel.transactionDate,
                              cancelType: type))
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] _ in
                self?.view?.hideLoader() {
                    self?.coordinator.cancelTransfer(type: type)
                }
            }
            .onError {[weak self] _ in
                self?.view?.hideLoader {
                    self?.showServiceInaccessibleError()
                }
            }
    }
    
    func confirmTransaction() {
        guard let viewModel = viewModel else { return }
        timer.stopTimer()
        view?.showLoader()
        
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
}
