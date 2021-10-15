import Models
import Commons
import DomainCommon
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
    private let viewModel: BLIKTransactionViewModel?
    
    let dependenciesResolver: DependenciesResolver
    private let timer = TimerHandler()
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()

    private var cancelBLIKTransactionUseCase: CancelBLIKTransactionProtocol {
        dependenciesResolver.resolve()
    }
    
    private var acceptBLIKTransactionUseCase: AcceptBLIKTransactionProtocol {
        dependenciesResolver.resolve()
    }

    init(dependenciesResolver: DependenciesResolver, viewModel: BLIKTransactionViewModel?) {
        self.dependenciesResolver = dependenciesResolver
        self.viewModel = viewModel
    }
}

extension BLIKConfirmationPresenter: BLIKConfirmationPresenterProtocol {
    func viewDidLoad() {
        guard let viewModel = viewModel else { return }
        let time = viewModel.remainingTime + (viewModel.transferType == .blikWebPurchases ? BLIK_WEB_PURCHASE_DURATION : BLIK_OTHER_DURATION)
        startCountdown(totalDuration: time , remainingDuration: time)
        view?.setViewModel(viewModel)
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
            .execute(on: DispatchQueue.global())
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
            .execute(on: DispatchQueue.global())
            .onSuccess { [weak self] _ in
                self?.view?.hideLoader() {
                    self?.coordinator.goToSummary()
                }
            }
            .onError {[weak self] error in
                guard let errorKey = error.getErrorDesc() else {
                    self?.view?.hideLoader {
                        self?.showServiceInaccessibleError()
                    }
                    return
                }
            
                self?.view?.hideLoader {
                    self?.showError(with: errorKey)
                }
            }
    }

    func showServiceInaccessibleError() {
        view?.showServiceInaccessibleMessage {[weak self] in
            self?.coordinator.goToGlobalPosition()
        }
    }
    
    func showError(with key: String) {
        view?.showErrorMessage(localized(key)) {[weak self] in
            self?.coordinator.goToGlobalPosition()
        }
    }
}
