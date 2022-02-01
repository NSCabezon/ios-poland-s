import CoreFoundationLib
import PLUI
import CoreFoundationLib

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
                                self?.coordinator.showSummary(with: summaryModel)
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
                } else {
                    self?.view?.hideLoader {
                        self?.showServiceInaccessibleError()
                        return
                    }
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
