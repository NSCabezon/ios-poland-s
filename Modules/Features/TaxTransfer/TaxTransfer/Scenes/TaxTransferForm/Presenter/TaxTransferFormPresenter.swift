//
//  TaxTransferFormPresenter.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

import CoreFoundationLib
import PLUI
import PLCommons
import PLCommonOperatives

protocol TaxTransferFormPresenterProtocol: AccountForDebitSelectorDelegate,
                                           TaxPayerSelectorDelegate,
                                           TaxBillingPeriodSelectorDelegate {
    var view: TaxTransferFormView? { get set }
    
    func viewDidLoad()
    func getTaxFormConfiguration() -> TaxFormConfiguration
    func didTapAccountSelector()
    func didTapTaxPayer()
    func didTapTaxAuthority()
    func didTapBack()
    func didTapClose()
    func didTapBillingPeriod()
    func didTapDone(with data: TaxTransferFormFields)
    func didUpdateFields(with fields: TaxTransferFormFields)
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo?)
    func didSelectTaxAuthority(_ taxAuthority: SelectedTaxAuthority)
    func didAddTaxPayer(_ taxPayer: TaxPayer)
}

final class TaxTransferFormPresenter {
    weak var view: TaxTransferFormView?

    private let dependenciesResolver: DependenciesResolver
    private let currency: String
    private var formData: TaxTransferFormData
    private var selectedAccount: AccountForDebit?
    private var selectedTaxPayer: TaxPayer?
    private var selectedTaxAuthority: SelectedTaxAuthority?
    private var selectedPayerInfo: SelectedTaxPayerInfo?
    private var selectedPeriod: TaxTransferBillingPeriodType?
    private var selectedBillingYear: String?
    private var selectedPeriodNumber: Int?
    
    init(
        currency: String,
        dependenciesResolver: DependenciesResolver
    ) {
        self.currency = currency
        self.dependenciesResolver = dependenciesResolver
        self.formData = TaxTransferFormData(
            sourceAccounts: [],
            taxPayers: [],
            predefinedTaxAuthorities: [],
            taxSymbols: []
        )
    }
}

private extension TaxTransferFormPresenter {
    var coordinator: TaxTransferFormCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    var validator: TaxTransferFormValidating {
        dependenciesResolver.resolve()
    }
    var taxTransferFormDataProvider: TaxTransferFormDataProviding {
        dependenciesResolver.resolve()
    }
    var accountViewModelMapper: TaxTransferAccountViewModelMapping {
        dependenciesResolver.resolve()
    }
    var accountsStateMapper: SourceAccountsStateMapping {
        dependenciesResolver.resolve()
    }
    var taxPayerViewModelMapper: TaxPayerViewModelMapping {
        dependenciesResolver.resolve()
    }
    var taxAuthorityViewModelMapper: TaxAuthorityViewModelMapping {
        dependenciesResolver.resolve()
    }
    var taxBillingPeriodViewModelMapper: TaxBillingPeriodViewModelMapping {
        dependenciesResolver.resolve()
    }
    var confirmationDialogFactory: ConfirmationDialogProducing {
        return dependenciesResolver.resolve()
    }
}

extension TaxTransferFormPresenter: TaxTransferFormPresenterProtocol {    
    func didSelectTaxBillingPeriod(form: TaxTransferBillingPeriodForm) {
        selectedPeriod = form.periodType
        selectedBillingYear = form.year
        
        switch selectedPeriod {
        case .year:
            selectedPeriodNumber = Int(form.year)
        case .day:
            selectedPeriodNumber = Int(form.day ?? "")
        default:
            selectedPeriodNumber = form.periodNumber
        }
        
        updateViewWithLatestViewModel()
    }
    
    func viewDidLoad() {
        view?.showLoader()
        taxTransferFormDataProvider.getData { [weak self] result in
            self?.view?.hideLoader(completion: {
                self?.handleUseCaseResult(result)
            })
        }
    }
    
    func getTaxFormConfiguration() -> TaxFormConfiguration {
        dependenciesResolver.resolve(for: TaxFormConfiguration.self)
    }
    
    func didTapAccountSelector() {
        coordinator.showAccountSelector(
            with: formData.sourceAccounts,
            selectedAccountNumber: selectedAccount?.number,
            mode: .changeDefaultAccount
        )
    }
    
    func didSelectAccount(withAccountNumber accountNumber: String) {
        selectedAccount = formData.sourceAccounts.first { $0.number == accountNumber }
        updateViewWithLatestViewModel()
    }
    
    func didTapTaxPayer() {
        coordinator.showTaxPayerSelector(
            with: formData.taxPayers,
            selectedTaxPayer: selectedTaxPayer
        )
    }
    
    func didTapTaxAuthority() {
        coordinator.showTaxAuthoritySelector(
            with: formData.predefinedTaxAuthorities,
            selectedTaxAuthority: selectedTaxAuthority,
            taxSymbols: formData.taxSymbols
        )
    }
    
    func didTapBillingPeriod() {
        coordinator.showTaxBillingPeriodSelector()
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    func didTapClose() {
        let closeConfirmationDialog = confirmationDialogFactory.createEndProcessDialog(
            confirmAction: { [weak self] in
                self?.coordinator.close()
            },
            declineAction: {}
        )
        view?.showDialog(closeConfirmationDialog)
    }
    
    func didTapDone(with data: TaxTransferFormFields) {
        // TODO:- Implement in TAP-2186
    }
    
    func didUpdateFields(with fields: TaxTransferFormFields) {
        let validationResult = validator.validateFields(fields)

        switch validationResult {
        case .valid:
            view?.enableDoneButton()
        case let .invalid(messages):
            view?.disableDoneButton(with: messages)
        }
    }
    
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo?) {
        selectedTaxPayer = taxPayer
        
        if let selectedPayerInfo = selectedPayerInfo {
            self.selectedPayerInfo = selectedPayerInfo
        } else {
            self.selectedPayerInfo = getSelectedInfo(from: taxPayer)
        }
        
        updateViewWithLatestViewModel()
    }
    
    func didSelectTaxAuthority(_ taxAuthority: SelectedTaxAuthority) {
        selectedTaxAuthority = taxAuthority
        updateViewWithLatestViewModel()
    }
    
    func didAddTaxPayer(_ taxPayer: TaxPayer) {
        let currentFormData = formData
        var currentTaxPayers = formData.taxPayers
        currentTaxPayers.append(taxPayer)
        
        formData = TaxTransferFormData(
            sourceAccounts: currentFormData.sourceAccounts,
            taxPayers: currentTaxPayers,
            predefinedTaxAuthorities: currentFormData.predefinedTaxAuthorities,
            taxSymbols: currentFormData.taxSymbols
        )
    }
}

private extension TaxTransferFormPresenter {
    func handleUseCaseResult(_ result: Result<TaxTransferFormData, GetTaxTransferDataUseCaseError>) {
        switch result {
        case let .success(data):
            handleFetchedTaxFormData(data)
        case .failure:
            view?.showErrorMessage(localized("pl_generic_randomError"), onConfirm: { [weak self] in
                self?.coordinator.back()
            })
        }
    }
    
    func handleFetchedTaxFormData(_ data: TaxTransferFormData) {
        formData = data
        
        switch accountsStateMapper.map(data.sourceAccounts) {
        case .listIsEmpty:
            showEmptyAccountsListAlert()
        case let .listContainsDefaultAccount(defaultAccount):
            selectAccount(defaultAccount)
        case let .listContainsSingleNonDefaultAccount(onlyAccount):
            selectAccount(onlyAccount)
        case let .listContainsMultipleNonDefaultAccounts(accounts):
            coordinator.showAccountSelector(
                with: accounts,
                selectedAccountNumber: nil,
                mode: .mustSelectDefaultAccount
            )
        }
    }
    
    func showEmptyAccountsListAlert() {
        view?.showErrorMessage(
            title: localized("pl_popup_noSourceAccTitle"),
            message: localized("pl_popup_noSourceAccParagraph"),
            actionButtonTitle: localized("generic_button_understand"),
            closeButton: .none,
            onConfirm: { [weak self] in self?.coordinator.back() }
        )
    }
    
    func updateViewWithLatestViewModel() {
        let currentFormData = view?.getCurrentFormFields()
        let viewModel = TaxTransferFormViewModel(
            account: getAccountViewModel(),
            taxPayer: getTaxPayerViewModel(),
            taxAuthority: getTaxAuthorityViewModel(),
            billingPeriod: getBillingPeriod(),
            sendAmount: TaxTransferFormViewModel.AmountViewModel(
                amount: currentFormData?.amount ?? "",
                currency: currency
            ),
            obligationIdentifier: currentFormData?.obligationIdentifier ?? ""
        )
        view?.setViewModel(viewModel)
    }
    
    func selectAccount(_ account: AccountForDebit) {
        selectedAccount = account
        updateViewWithLatestViewModel()
    }
    
    func getAccountViewModel() -> Selectable<TaxTransferFormViewModel.AccountViewModel> {
        guard let account = selectedAccount else {
            return .unselected
        }
        let isEditButtonEnabled = (formData.sourceAccounts.count > 1)
        let viewModel = accountViewModelMapper.map(account, isEditButtonEnabled: isEditButtonEnabled)
        return .selected(viewModel)
    }
    
    func getTaxPayerViewModel() -> Selectable<TaxTransferFormViewModel.TaxPayerViewModel> {
        guard let taxPayer = selectedTaxPayer,
              let selectedInfo = selectedPayerInfo else {
            return .unselected
        }
        let viewModel = taxPayerViewModelMapper.map(taxPayer, selectedInfo: selectedInfo)
        return .selected(viewModel)
    }
    
    func getTaxAuthorityViewModel() -> Selectable<TaxTransferFormViewModel.TaxAuthorityViewModel> {
        guard let taxAuthority = selectedTaxAuthority else {
            return .unselected
        }
        
        let viewModel = taxAuthorityViewModelMapper.map(taxAuthority)
        return .selected(viewModel)
    }
    
    func getSelectedInfo(from payer: TaxPayer) -> SelectedTaxPayerInfo {
        return SelectedTaxPayerInfo(
            taxIdentifier: payer.taxIdentifier ?? payer.secondaryTaxIdentifierNumber,
            idType: payer.idType
        )
    }
    
    func getBillingPeriod() -> TaxTransferFormViewModel.BillingPeriodVisibility {
        guard
            let taxSymbol = selectedTaxAuthority?.selectedTaxSymbol,
            taxSymbol.isTimePeriodRequired
        else {
            return .hidden
        }
            
        guard let period = selectedPeriod else {
            return .visible(.unselected)
        }
        
        let viewModel = taxBillingPeriodViewModelMapper.map(
            period,
            year: selectedBillingYear ?? "",
            periodNumber: selectedPeriodNumber
        )
        
        return .visible(.selected(viewModel))
    }
}
