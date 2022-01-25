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
    func didTapDone(with data: TaxTransferFormFieldsData)
    func didUpdateFields(with data: TaxTransferFormFieldsData)
}

final class TaxTransferFormPresenter {
    private let dependenciesResolver: DependenciesResolver
    private let currency: String
    private var fetchedAccounts: [AccountForDebit] = []
    private var selectedAccount: AccountForDebit?
    weak var view: TaxTransferFormView?
    
    init(
        currency: String,
        dependenciesResolver: DependenciesResolver
    ) {
        self.currency = currency
        self.dependenciesResolver = dependenciesResolver
    }
}

private extension TaxTransferFormPresenter {
    var coordinator: TaxTransferFormCoordinatorProtocol {
        dependenciesResolver.resolve()
    }
    var validator: TaxTransferFormValidating {
        dependenciesResolver.resolve()
    }
    var getAccountsUseCase: GetAccountsForDebitProtocol {
        dependenciesResolver.resolve()
    }
    var accountViewModelMapper: TaxTransferAccountViewModelMapping {
        dependenciesResolver.resolve()
    }
    var useCaseHandler: UseCaseHandler {
        return dependenciesResolver.resolve()
    }
}

extension TaxTransferFormPresenter: TaxTransferFormPresenterProtocol {
    func viewDidLoad() {
        view?.showLoader()
        Scenario(useCase: getAccountsUseCase)
            .execute(on: useCaseHandler)
            .onSuccess { [weak self] accounts in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.handleFetchedAccounts(accounts)
                })
            }
            .onError { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.view?.hideLoader(completion: {
                    strongSelf.view?.showServiceInaccessibleMessage(onConfirm: { [weak self] in
                        self?.coordinator.back()
                    })
                })
            }
    }
    
    func getTaxFormConfiguration() -> TaxFormConfiguration {
        dependenciesResolver.resolve(for: TaxFormConfiguration.self)
    }
    
    func didTapAccountSelector() {
        coordinator.showAccountSelector(
            with: fetchedAccounts,
            selectedAccountNumber: selectedAccount?.number,
            mode: .changeDefaultAccount
        )
    }
    
    func didSelectAccount(withAccountNumber accountNumber: String) {
        selectedAccount = fetchedAccounts.first { $0.number == accountNumber }
        refreshView()
    }
    
    func didTapTaxPayer() {
        // TODO:- Implement in TAP-2492
    }
    
    func didTapTaxAuthority() {
        // TODO: Implement in TAP-2517
    }
    
    func didTapBack() {
        coordinator.back()
    }
    
    func didTapDone(with data: TaxTransferFormFieldsData) {
        // TODO:- Implement in TAP-2186
    }
    
    func didUpdateFields(with data: TaxTransferFormFieldsData) {
        let validationResult = validator.validateData(data)
        switch validationResult {
        case .valid:
            view?.enableDoneButton()
        case let .invalid(messages):
            view?.disableDoneButton(with: messages)
        }
    }
}

private extension TaxTransferFormPresenter {
    func handleFetchedAccounts(_ accounts: [AccountForDebit]) {
        fetchedAccounts = accounts
        
        guard !accounts.isEmpty else {
            showEmptyAccountsListAlert()
            return
        }
        
        let potentialDefaultAccount = accounts.first { $0.defaultForPayments }
        if let defaultAccount = potentialDefaultAccount {
            selectedAccount = defaultAccount
            refreshView()
        } else {
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
    
    func refreshView() {
        let currentFormData = view?.getCurrentFormData()
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
    
    func getAccountViewModel() -> Selectable<TaxTransferFormViewModel.AccountViewModel> {
        guard let account = selectedAccount else {
            return .unselected
        }
        let isEditButtonEnabled = (fetchedAccounts.count > 1)
        let viewModel = accountViewModelMapper.map(account, isEditButtonEnabled: isEditButtonEnabled)
        return .selected(viewModel)
    }
    
    func getTaxPayerViewModel() -> Selectable<TaxTransferFormViewModel.TaxPayerViewModel> {
        return .unselected // TODO:- Add actual viewModel in TAP-2492
    }
    
    func getTaxAuthorityViewModel() -> Selectable<TaxTransferFormViewModel.TaxAuthorityViewModel> {
        return .unselected // TODO: Add actual viewModel in TAP-2517
    }
}
