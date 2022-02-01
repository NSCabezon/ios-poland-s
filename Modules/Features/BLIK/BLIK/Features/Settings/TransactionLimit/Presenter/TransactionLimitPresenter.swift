import CoreFoundationLib
import PLCommons
import PLUI

protocol TransactionLimitPresenterProtocol {
    func viewDidLoad()
    func didPressSave(viewModel: TransactionLimitViewModel)
    func didPressClose(viewModel: TransactionLimitViewModel)
    func didUpdateForm(viewModel: TransactionLimitViewModel)
}

final class TransactionLimitPresenter: TransactionLimitPresenterProtocol {
    private let dependenciesResolver: DependenciesResolver
    private let coordinator: BlikSettingsCoordinatorProtocol
    private var initialViewModel: TransactionLimitViewModel
    private let setTransactionsLimitUseCase: SetTransactionsLimitUseCaseProtocol
    private let validator: TransactionsLimitValidation
    private let confirmationDialogFactory: ConfirmationDialogProducing
    private let viewModelMapper: TransactionLimitViewModelMapping
    private let wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>
    private let walletParams: WalletParams
    private var useCaseHandler: UseCaseHandler {
        return dependenciesResolver.resolve(for: UseCaseHandler.self)
    }
    private var loadWalletUseCase: GetWalletsActiveProtocol {
        return dependenciesResolver.resolve()
    }
    weak var view: TransactionLimitViewController?
    
    init(
        dependenciesResolver: DependenciesResolver,
        wallet: SharedValueBox<GetWalletUseCaseOkOutput.Wallet>,
        walletParams: WalletParams,
        viewModelMapper: TransactionLimitViewModelMapping,
        setTransactionsLimitUseCase: SetTransactionsLimitUseCaseProtocol,
        validator: TransactionsLimitValidation,
        coordinator: BlikSettingsCoordinatorProtocol,
        confirmationDialogFactory: ConfirmationDialogProducing = ConfirmationDialogFactory()
    ) {
        self.dependenciesResolver = dependenciesResolver
        self.initialViewModel = viewModelMapper.map(
            wallet: wallet.getValue(),
            params: walletParams
        )
        self.setTransactionsLimitUseCase = setTransactionsLimitUseCase
        self.validator = validator
        self.coordinator = coordinator
        self.confirmationDialogFactory = confirmationDialogFactory
        self.viewModelMapper = viewModelMapper
        self.wallet = wallet
        self.walletParams = walletParams
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
                self?.coordinator.back()
            } declineAction: {
            }.showIn(view)
            return
        }
        
        coordinator.back()
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
                
        switch state {
        case .valid:
            view?.clearValidationMessages()
        case .invalid:
            let purchaseLimitValidation = getLimitValidationMessage(purchaseLimitValue)
            let withdrawLimitValidation = getLimitValidationMessage(withdrawLimitValue)
            
            let invalidFormMessage = InvalidLimitFormMessages(invalidPurchaseLimitMessage: purchaseLimitValidation,
                                                              invalidWithdrawLimitMessage: withdrawLimitValidation)
            
            view?.showInvalidFormMessage(invalidFormMessage)
        }
        
        view?.setIsSaveButtonEnabled(state.isAllowed)
    }
}

private extension TransactionLimitPresenter {
    func getLimitValidationMessage(_ amount: Decimal) -> String? {
        if amount <= 0 {
            return localized("pl_blik_text_validAmount")
        } else {
            return nil
        }
    }
    
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
                    closeButton: .available,
                    onConfirm: nil
                )
            }
            
        case .invalid(let reason):
            switch reason {
            case .illegalLimitDecrease:
                confirmationDialogFactory.createLimitIncreasingDialog { [weak self] in
                    self?.saveTransactionLimit(model: newModel)
                } declineAction: {
                    
                }.showIn(view)
            default:
                break
            }
        }
    }
    
    func saveTransactionLimit(model: TransactionLimitModel) {
        view?.showLoader()
        let input = SetTransactionsLimitUseCaseInput(
            transactionLimit: model
        )
        Scenario(useCase: setTransactionsLimitUseCase, input: input)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] response in
                self?.view?.hideLoader(completion: {
                    self?.fetchWalletAndGoBackToSettings()
                })
            }
            .onError { [weak self] error in
                guard let strongSelf = self else { return }
                
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: nil)
                })
            }
    }
    
    func fetchWalletAndGoBackToSettings() {
        Scenario(useCase: loadWalletUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] response in
                self?.view?.hideLoader(completion: {
                    self?.handleUpdatedWallet(with: response)
                })
            }
            .onError { [weak self] _ in
                self?.view?.hideLoader(completion: {
                    self?.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                        self?.coordinator.closeToGlobalPosition()
                    })
                })
            }
    }
    
    func handleUpdatedWallet(with response: GetWalletUseCaseOkOutput) {
        switch response.serviceStatus {
        case let .available(fetchedWallet):
            self.wallet.setValue(fetchedWallet)
            coordinator.showLimitUpdateSuccess()
            let newViewModel = viewModelMapper.map(
                wallet: fetchedWallet,
                params: self.walletParams
            )
            view?.setViewModel(viewModel: newViewModel)
        case .unavailable:
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                self?.coordinator.closeToGlobalPosition()
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
