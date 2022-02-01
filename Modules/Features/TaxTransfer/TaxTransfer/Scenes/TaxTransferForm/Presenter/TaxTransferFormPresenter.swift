//
//  TaxTransferFormPresenter.swift
//  TaxTransfer
//
//  Created by 185167 on 06/12/2021.
//

import Commons
import CoreFoundationLib
import PLCommons
import PLCommonOperatives

protocol TaxTransferFormPresenterProtocol: AccountForDebitSelectorDelegate {
    var view: TaxTransferFormView? { get set }
    
    func viewDidLoad()
    func getTaxFormConfiguration() -> TaxFormConfiguration
    func didTapAccountSelector()
    func didTapTaxPayer()
    func didTapTaxAuthority()
    func didTapBack()
    func didTapDone(with data: TaxTransferFormFields)
    func didUpdateFields(with fields: TaxTransferFormFields)
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo)
}

final class TaxTransferFormPresenter {
    weak var view: TaxTransferFormView?

    private let dependenciesResolver: DependenciesResolver
    private let currency: String
    private var formData: TaxTransferFormData
    private var selectedAccount: AccountForDebit?
    private var selectedTaxPayer: TaxPayer?
    private var selectedPayerInfo: SelectedTaxPayerInfo?
    
    init(
        currency: String,
        dependenciesResolver: DependenciesResolver
    ) {
        self.currency = currency
        self.dependenciesResolver = dependenciesResolver
        self.formData = TaxTransferFormData(
            sourceAccounts: []
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
        return dependenciesResolver.resolve()
    }
}

extension TaxTransferFormPresenter: TaxTransferFormPresenterProtocol {
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
        coordinator.didTapPayerSelectorView(
            with: selectedTaxPayer
        )
    }
    
    func didTapTaxAuthority() {
        // TODO: Implement in TAP-2517
    }
    
    func didTapBack() {
        coordinator.back()
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
    
    func didSelectTaxPayer(_ taxPayer: TaxPayer, selectedPayerInfo: SelectedTaxPayerInfo) {
        self.selectedPayerInfo = selectedPayerInfo
        selectedTaxPayer = taxPayer
        updateViewWithLatestViewModel()
    }
}

private extension TaxTransferFormPresenter {
    func handleUseCaseResult(_ result: Result<TaxTransferFormData, GetTaxTransferDataUseCaseError>) {
        switch result {
        case let .success(data):
            handleFetchedTaxFormData(data)
        case .failure:
            view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
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
            title: "#Informacja",
            message: "#Brak rachunków źródłowych",
            actionButtonTitle: localized("generic_link_ok"),
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
        return .unselected // TODO: Add actual viewModel in TAP-2517
    }
}
