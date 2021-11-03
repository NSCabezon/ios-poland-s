import Commons
import PLUI

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
    private var queue: DispatchQueue
    private let viewModel: MobileTransferViewModel?
    private let confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    private let isDstAccInternal: Bool
    private let dstAccNo: String

    private var acceptTransactionUseCase: AcceptTransactionProtocol {
        dependenciesResolver.resolve()
    }


    init(dependenciesResolver: DependenciesResolver,
         viewModel: MobileTransferViewModel,
         isDstAccInternal: Bool,
         dstAccNo: String,
         queue: DispatchQueue = .global()) {
        self.dependenciesResolver = dependenciesResolver
        self.queue = queue
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
        
        self.view?.showLoader()
        Scenario(useCase: acceptTransactionUseCase,
                 input: .init(form: viewModel, isDstAccInternal: isDstAccInternal, dstAccNo: dstAccNo))
            .execute(on: queue)
            .onSuccess { [weak self] result in
                self?.view?.hideLoader {
                    self?.coordinator.showSummary(with: result.summary)
                }
            }
            .onError { [weak self] error in
                self?.view?.hideLoader {
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
