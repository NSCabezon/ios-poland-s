import Commons
import PLCommons
import Commons
import PLUI

protocol TransactionLimitPresenterProtocol {
    func viewDidLoad()
    func didPressSave(viewModel: TransactionLimitViewModel)
    func didPressClose(viewModel: TransactionLimitViewModel)
    func didUpdateForm(viewModel: TransactionLimitViewModel)
}

final class TransactionLimitPresenter: TransactionLimitPresenterProtocol {
    private let coordinator: BlikSettingsCoordinatorProtocol
    private var initialViewModel: TransactionLimitViewModel
    private let setTransactionsLimitUseCase: SetTransactionsLimitUseCaseProtocol
    private let validator: TransactionsLimitValidation
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let viewModelMapper: TransactionLimitViewModelMapping
    weak var view: TransactionLimitViewController?
    
    init(wallet: GetWalletUseCaseOkOutput.Wallet,
         viewModelMapper: TransactionLimitViewModelMapping,
         setTransactionsLimitUseCase: SetTransactionsLimitUseCaseProtocol,
         validator: TransactionsLimitValidation,
         coordinator: BlikSettingsCoordinatorProtocol,
         confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    ) {
        self.initialViewModel = viewModelMapper.map(wallet)
        self.setTransactionsLimitUseCase = setTransactionsLimitUseCase
        self.validator = validator
        self.coordinator = coordinator
        self.confirmationDialogFactory = confirmationDialogFactory
        self.viewModelMapper = viewModelMapper
    }
    
    func viewDidLoad() {
        view?.setIsSaveButtonEnabled(false)
        view?.setViewModel(viewModel: initialViewModel)
    }

    func didPressSave(viewModel: TransactionLimitViewModel) {
        guard let initialWithdrawLimitValue = viewModelMapper.mapAmount(initialViewModel.withdrawLimitValue),
              let initialPurchaseLimitValue = viewModelMapper.mapAmount(initialViewModel.purchaseLimitValue),
              let withdrawLimitValue = viewModelMapper.mapAmount(viewModel.withdrawLimitValue),
              let purchaseLimitValue = viewModelMapper.mapAmount(viewModel.purchaseLimitValue)
        else {
            return
        }
        
        validateAndSaveTransactionLimit(
            oldModel: TransactionLimitModel(
                withdrawLimit: initialWithdrawLimitValue,
                purchaseLimit: initialPurchaseLimitValue
            ),
            newModel: TransactionLimitModel(
                withdrawLimit: withdrawLimitValue,
                purchaseLimit: purchaseLimitValue
            )
        )
    }
    
    func didPressClose(viewModel: TransactionLimitViewModel) {
        guard let view = view else { return }
        
        let newWithdrawLimit = viewModel.withdrawLimitValue
        let newPurchaseLimit = viewModel.purchaseLimitValue
        
        let didChangeWithdrawLimit = newWithdrawLimit != initialViewModel.withdrawLimitValue
        let didChangePurchaseLimit = newPurchaseLimit != initialViewModel.purchaseLimitValue
        
        guard !didChangeWithdrawLimit && !didChangePurchaseLimit else {
            confirmationDialogFactory.createEndProcessDialog {[weak self] in
                self?.coordinator.close()
            } declineAction: {
            }.showIn(view)
            return
        }
        
        coordinator.close()
    }
    
    func didUpdateForm(viewModel: TransactionLimitViewModel) {
        guard let initialWithdrawLimitValue = viewModelMapper.mapAmount(initialViewModel.withdrawLimitValue),
              let initialPurchaseLimitValue = viewModelMapper.mapAmount(initialViewModel.purchaseLimitValue),
              let withdrawLimitValue = viewModelMapper.mapAmount(viewModel.withdrawLimitValue),
              let purchaseLimitValue = viewModelMapper.mapAmount(viewModel.purchaseLimitValue)
        else {
            view?.setIsSaveButtonEnabled(false)
            return
        }
        
        let state = validator.validate(
            oldModel: TransactionLimitModel(
                withdrawLimit: initialWithdrawLimitValue,
                purchaseLimit: initialPurchaseLimitValue
            ),
            newModel: TransactionLimitModel(
                withdrawLimit: withdrawLimitValue,
                purchaseLimit: purchaseLimitValue
            )
        )
        view?.setIsSaveButtonEnabled(state.isAllowed)
    }
}

private extension TransactionLimitPresenter {
    func validateAndSaveTransactionLimit(oldModel: TransactionLimitModel, newModel: TransactionLimitModel) {
        guard let view = view else { return }
        
        let validationResult = validator.validate(oldModel: oldModel, newModel: newModel)
        
        switch validationResult {
        case .valid(let validOption):
            switch validOption {
            case .none:
                saveTransactionLimit(model: newModel)
            case .limitsDidNotChange:
                view.setIsSaveButtonEnabled(false)
            case .limitIncreaseNotice:
                view.showErrorMessage(
                    title: localized("pl_blik_title_limitNoAllowed"),
                    message: localized("pl_blik_text_limitNoAllowedInfo"),
                    actionButtonTitle: localized("generic_link_ok"),
                    onConfirm: nil
                )
            }
            
        case .invalid(let reason):
            switch reason {
            case .limitsNotGreaterThanZero:
                view.showErrorMessage("#Błąd zmiany limitów tranzakcji", onConfirm: nil)
            case .illegalLimitDecrease:
                confirmationDialogFactory.createLimitIncreasingDialog { [weak self] in
                    self?.saveTransactionLimit(model: newModel)
                } declineAction: {
                    
                }.showIn(view)
            }
        }
    }
    
    func saveTransactionLimit(model: TransactionLimitModel) {
        view?.showLoader()
        Scenario(useCase: setTransactionsLimitUseCase, input: model)
            .execute(on: DispatchQueue.global())
            .onSuccess { [weak self] response in
                self?.view?.hideLoader(completion: {
                    self?.coordinator.close()
                })
            }
            .onError { [weak self] error in
                guard let strongSelf = self else { return }
                
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
}

private extension TransactionsLimitValidationResult {
    var isAllowed: Bool {
        switch self {
        case .invalid(let reason):
            switch reason {
            case .limitsNotGreaterThanZero:
                return false
            case .illegalLimitDecrease:
                return true
            }
        case let .valid(additionalInfo):
            switch additionalInfo {
            case .none, .limitIncreaseNotice:
                return true
            case .limitsDidNotChange:
                return false
            }
        }
    }
}
